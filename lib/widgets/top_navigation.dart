import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class TopNavigation extends HookConsumerWidget {
  final String? title;
  final bool showBack;
  final bool showUser;
  final bool showFilter;
  final bool showInfo;
  final VoidCallback? onBack;
  final Widget? rightContent;

  const TopNavigation({
    super.key,
    this.title,
    this.showBack = false,
    this.showUser = false,
    this.showFilter = false,
    this.showInfo = false,
    this.onBack,
    this.rightContent,
  });

  String getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    final words = name.trim().split(" ");
    return words.map((e) => e[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userFullName = authState.userFullName;
    final userLocation = authState.userLocation;
    final authNotifier = ref.read(authProvider.notifier);

    // Refresh location when widget builds and user is shown
    useEffect(() {
      if (showUser) {
        Future.microtask(() => authNotifier.updateLocation());
      }
      return null;
    }, [showUser]);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            // Left side
            Expanded(
              child: Row(
                children: [
                  if (showBack)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: onBack ?? () => context.pop(),
                      ),
                    ),
                  if (showUser)
                    Flexible(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              getInitials(userFullName),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userFullName ?? 'Guest',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        userLocation ?? 'Fetching location...',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (title != null && !showUser)
                    Flexible(
                      child: Text(
                        title!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Right side
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rightContent != null) rightContent!,
                if (showFilter)
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                if (showInfo)
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {},
                  ),
                if (showUser) ...[
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.language),
                    onPressed: () {},
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}