# Flutter Architecture & State Management Guide
**Pattern:** Feature-First Clean Architecture + Riverpod (MVVM + Repository Pattern)  
**Project:** `standard_architecture`  

---

## 1. Executive Summary & Core Philosophy

This project implements **Feature-First Clean Architecture** with **Riverpod (v2/v3 code generation)** and **Freezed**.

### The Golden Rule
> **Dependencies only point inward.**
> The UI knows about Controllers. Controllers know about Repositories. Repositories know about Data Sources.  
> **The Domain Layer knows about NO ONE.** It is pure, untouched Dart code.

```
┌─────────────────────────────────────────────────────────────┐
│ PRESENTATION LAYER (Flutter UI & Riverpod State)            │
│ Screens ──► Widgets ──► Controllers (AsyncNotifier)         │
└──────────────────────────────┬──────────────────────────────┘
                               │ calls
┌──────────────────────────────▼──────────────────────────────┐
│ DOMAIN LAYER (Pure Dart Business Rules)                     │
│ Entities ◄──► Abstract Repository Contracts                 │
└──────────────────────────────▲──────────────────────────────┘
                               │ implemented by
┌──────────────────────────────┴──────────────────────────────┐
│ DATA LAYER (Infrastructure & Serialization)                 │
│ Repository Impl ──► Remote/Local Data Sources ──► Dio/HTTP  │
│ Models (Freezed DTOs) ──.toEntity()──► Domain Entities      │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. The Dependency Chain: Who Uses What? (Step-by-Step)

Here is the exact dependency injection chain showing **where each piece is defined**, **who consumes it**, and the **exact line of code connecting them**:

```
[ dioProvider ] (lib/core/network/dio_provider.dart)
       │
       ▼ used in:
[ postRemoteDataSourceProvider ] (lib/features/posts/data/datasources/post_remote_data_source.dart)
       │
       ▼ used in:
[ postRepositoryProvider ] (lib/features/posts/data/repositories/post_repository_impl.dart)
       │
       ▼ used in:
[ postsControllerProvider ] (lib/features/posts/presentation/controllers/posts_controller.dart)
       │
       ▼ used in:
[ PostsScreen (UI) ] (lib/features/posts/presentation/screens/posts_screen.dart)
       │
       ▼ registered in:
[ goRouterProvider ] (lib/core/router/app_router.dart)
       │
       ▼ consumed by:
[ App (MaterialApp.router) ] (lib/app.dart)
```

### The Code-Level Wiring (File by File):

#### Link 1: `dioProvider` is used in `PostRemoteDataSource`
* **Defined in:** `lib/core/network/dio_provider.dart`
* **Consumed in:** `lib/features/posts/data/datasources/post_remote_data_source.dart`
* **The Connection Code:**
  ```dart
  @riverpod
  PostRemoteDataSource postRemoteDataSource(Ref ref) {
    // 🔗 INJECTION: Reads the shared Dio instance
    final dio = ref.watch(dioProvider); 
    return PostRemoteDataSource(dio: dio);
  }
  ```

#### Link 2: `postRemoteDataSourceProvider` is used in `PostRepositoryImpl`
* **Defined in:** `lib/features/posts/data/datasources/post_remote_data_source.dart`
* **Consumed in:** `lib/features/posts/data/repositories/post_repository_impl.dart`
* **The Connection Code:**
  ```dart
  @riverpod
  PostRepository postRepository(Ref ref) {
    // 🔗 INJECTION: Reads the remote data source
    final remoteDataSource = ref.watch(postRemoteDataSourceProvider); 
    return PostRepositoryImpl(remoteDataSource: remoteDataSource);
  }
  ```

#### Link 3: `postRepositoryProvider` is used in `PostsController`
* **Defined in:** `lib/features/posts/data/repositories/post_repository_impl.dart`
* **Consumed in:** `lib/features/posts/presentation/controllers/posts_controller.dart`
* **The Connection Code:**
  ```dart
  @riverpod
  class PostsController extends _$PostsController {
    @override
    FutureOr<List<Post>> build() async {
      // 🔗 INJECTION: Calls the repository to fetch pure domain entities
      final repository = ref.watch(postRepositoryProvider); 
      return repository.getPosts();
    }
  }
  ```

#### Link 4: `postsControllerProvider` is used in `PostsScreen` (Widget)
* **Defined in:** `lib/features/posts/presentation/controllers/posts_controller.dart`
* **Consumed in:** `lib/features/posts/presentation/screens/posts_screen.dart`
* **The Connection Code:**
  ```dart
  class PostsScreen extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      // 🔗 OBSERVATION: Watches controller state and rebuilds on change
      final postsAsync = ref.watch(postsControllerProvider); 

      return postsAsync.when(
        data: (posts) => ListView.builder(...),
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      );
    }
  }
  ```

#### Link 5: `PostsScreen` is registered in `app_router.dart`
* **Defined in:** `lib/features/posts/presentation/screens/posts_screen.dart`
* **Consumed in:** `lib/core/router/app_router.dart`
* **The Connection Code:**
  ```dart
  @riverpod
  GoRouter goRouter(Ref ref) {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const PostsScreen(), // 🔗 ROUTE BINDING
        ),
      ],
    );
  }
  ```

#### Link 6: `goRouterProvider` is consumed by `App`
* **Defined in:** `lib/core/router/app_router.dart`
* **Consumed in:** `lib/app.dart`
* **The Connection Code:**
  ```dart
  class App extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      // 🔗 INJECTION: Supplies the router to Flutter's MaterialApp
      final router = ref.watch(goRouterProvider); 

      return MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.lightTheme,
      );
    }
  }
  ```

---

## 3. Data Transformation Chain: From Raw JSON to Pixels

Here is how data changes shape at each layer of the application:

```
[ Backend REST API ]
       │ returns: raw JSON String / Map
       ▼
[ PostRemoteDataSource ]
       │ uses: PostModel.fromJson(json) (Freezed DTO)
       ▼
[ PostRepositoryImpl ]
       │ converts: model.toEntity() (Pure Domain Entity)
       ▼
[ PostsController ]
       │ wraps in: AsyncData<List<Post>>
       ▼
[ PostsScreen / PostCard ]
       │ renders: Text(post.title), Text(post.body)
```

* **`PostModel` (Data Layer):** Handles raw JSON keys, nullable fallback values (`@Default('')`), and API serialization.
* **`model.toEntity()`:** Converts the DTO into the clean domain object.
* **`Post` (Domain Layer):** Pure immutable Dart class used by the UI and business logic. The UI never touches raw JSON keys!

---

## 4. Cross-Feature Communication Chain

How does Feature A talk to Feature B without tight coupling?

```
features/posts/presentation/controllers/favorites_controller.dart
       │
       ├─────────────────────────────────────────┐
       ▼ watched in (Feature 1):                 ▼ watched in (Feature 2):
PostCard (features/posts/widgets/post_card.dart)   ProfileScreen (features/auth/screens/profile_screen.dart)
[ Bookmark Star Button ]                           [ "Saved Posts (3)" Counter ]
```

Because Riverpod providers are globally accessible via `ref.watch()`, `ProfileScreen` in `features/auth` simply writes:
```dart
final favoriteCount = ref.watch(favoritesControllerProvider).length;
```
Neither feature needs to instantiate the other or pass `BuildContext` down long widget trees!

---

## 5. Directory Structure Reference

```
lib/
├── core/                         # Global code shared across multiple features
│   ├── errors/failures.dart      # Standardized failure and exception classes
│   ├── network/dio_provider.dart # Dio HTTP client instance & interceptors
│   ├── router/app_router.dart    # Declarative routing (GoRouter)
│   └── theme/app_theme.dart      # Color schemes, typography, component themes
│
├── features/                     # Business domain modules
│   ├── posts/                    # Feature 1: Social feed, details, comments
│   │   ├── domain/               # Pure Dart contracts & business objects
│   │   ├── data/                 # Networking, Freezed DTOs, repository implementations
│   │   └── presentation/         # Riverpod controllers, screens, modular widgets
│   │
│   └── auth/                     # Feature 2: User sessions & profile
│       ├── domain/
│       ├── data/
│       └── presentation/
│
├── app.dart                      # MaterialApp.router configuration
└── main.dart                     # Entry point with ProviderScope
```

---

## 6. Detailed File-by-File Guide

### A. The `core/` Directory (Shared Infrastructure)
| File | Defined Here | Consumed By | Why We Use It |
| :--- | :--- | :--- | :--- |
| `network/dio_provider.dart` | `dioProvider` | Any `RemoteDataSource` | Single shared connection pool, base URL, and timeouts. |
| `router/app_router.dart` | `goRouterProvider` | `app.dart` | Declarative routing with URL parameter support (`/posts/:id`). |
| `theme/app_theme.dart` | `AppTheme` | `app.dart` | Centralized Material 3 styling tokens. |
| `errors/failures.dart` | `Failure` subclasses | Repositories & Controllers | Clean error handling separated from low-level network errors. |

### B. The `domain/` Directory (Pure Business Logic)
| Component | What Lives Here | Consumed By | Why We Use It |
| :--- | :--- | :--- | :--- |
| `entities/` | `post.dart`, `auth_user.dart` | Repositories, Controllers, Screens | Pure Dart models with zero external dependencies. |
| `repositories/` | `post_repository.dart` (interface) | Controllers & Repository Implementations | Contract defining operations. Allows mocking for unit tests. |

### C. The `data/` Directory (Infrastructure & Serialization)
| Component | What Lives Here | Consumed By | Why We Use It |
| :--- | :--- | :--- | :--- |
| `models/` | `post_model.dart` (Freezed) | Data Sources & Repositories | JSON serialization with safe defaults. |
| `datasources/` | `post_remote_data_source.dart` | Repositories | Direct Dio HTTP calls (`/posts`). |
| `repositories/` | `post_repository_impl.dart` | Controllers | Implements domain contract, coordinates sources, maps DTOs to entities. |

### D. The `presentation/` Directory (UI & State)
| Component | What Lives Here | Consumed By | Why We Use It |
| :--- | :--- | :--- | :--- |
| `controllers/` | `posts_controller.dart` | Screens & Widgets | Manages `AsyncValue` state and actions (`refresh()`). |
| `screens/` | `posts_screen.dart` | `app_router.dart` | Full page layouts with `.when(...)` declarative handling. |
| `widgets/` | `post_card.dart`, `author_card.dart` | Screens | Modular, reusable UI components. |

---

## 7. Cheat Sheet: Recipe to Build Any New Feature

1. **Domain:** Create `Entity` and abstract `Repository` interface.
2. **Data:** Create Freezed `Model` (`.toEntity()`), `RemoteDataSource` (Dio), and `RepositoryImpl`.
3. **Controller:** Create `Controller` (`@riverpod class FeatureController extends _$FeatureController`).
4. **Presentation:** Build `Screen` (`ConsumerWidget`) and register route in `app_router.dart`.
5. **Generate:** Run `dart run build_runner build`.
