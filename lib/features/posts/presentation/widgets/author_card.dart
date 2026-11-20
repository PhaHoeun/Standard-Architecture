import 'package:flutter/material.dart';
import '../../../../core/widgets/frosted_container.dart';
import '../../domain/entities/user.dart';

class AuthorCard extends StatelessWidget {
  final User author;

  const AuthorCard({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FrostedContainer(
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      blur: 16,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isDark
                ? const Color(0xFF2563EB).withValues(alpha: 0.25)
                : const Color(0xFF0F172A).withValues(alpha: 0.08),
            child: Text(
              author.name.isNotEmpty ? author.name[0] : '?',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${author.email} • ${author.companyName}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
