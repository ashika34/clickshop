import 'package:click_shop/Feature/Home/widgets/themechange.dart';
import 'package:click_shop/config/app_route.dart';
import 'package:click_shop/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(drawerDarkModeProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final drawerWidth = (screenWidth * 0.86).clamp(300.0, 410.0);

    return Drawer(
      width: drawerWidth,
      elevation: 18,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 20),
            _DrawerMenuItem(
              icon: Icons.home_outlined,
              iconColor: AppColors.darkGreen,
              iconBackground: const Color(0xFFEAF7ED),
              label: 'Home',
              onTap: () {
                Scaffold.of(context).closeDrawer();
                context.go(AppRoutes.home);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.notifications_none_rounded,
              iconColor: const Color(0xFF5367D9),
              iconBackground: const Color(0xFFF0F1FF),
              label: 'Notifications',
              onTap: () {},
            ),
            _DrawerMenuItem(
              icon: Icons.settings_outlined,
              iconColor: const Color(0xFF2588C8),
              iconBackground: const Color(0xFFEAF6FC),
              label: 'Settings',
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Divider(color: Color(0xFFE6E8E6)),
            ),
            _ThemeMenuItem(
              enabled: darkMode,
              onChanged: ref.read(drawerDarkModeProvider.notifier).toggle,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: Divider(color: Color(0xFFE6E8E6)),
            ),
            _DrawerMenuItem(
              icon: Icons.logout_rounded,
              iconColor: const Color(0xFFE53935),
              iconBackground: const Color(0xFFFFEEEE),
              label: 'Logout',
              labelColor: const Color(0xFFD92F2F),
              onTap: () => context.go(AppRoutes.login),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 34, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainer,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 92,
            height: 92,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE1E6E1), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x16000000),
                  blurRadius: 16,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const CircleAvatar(
              backgroundColor: Color(0xFFE7F5E9),
              child: Icon(
                Icons.person_rounded,
                size: 52,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Ashika',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    const _PremiumBadge(),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'ashika@email.com',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF4DB),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.workspace_premium_rounded,
          size: 14,
          color: Color(0xFFB67C11),
        ),
        SizedBox(width: 3),
        Text(
          'Premium',
          style: TextStyle(
            color: Color(0xFF9B6710),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _DrawerMenuItem extends StatelessWidget {
  const _DrawerMenuItem({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 66,
      leading: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: iconBackground,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: iconColor, size: 27),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: labelColor ?? Theme.of(context).colorScheme.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 28,
      ),
    ),
  );
}

class _ThemeMenuItem extends StatelessWidget {
  const _ThemeMenuItem({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      minTileHeight: 66,
      leading: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF8F3),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(
          Icons.dark_mode_outlined,
          color: AppColors.darkGreen,
          size: 27,
        ),
      ),
      title: Text(
        'Dark Mode',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Switch.adaptive(
        value: enabled,
        activeTrackColor: AppColors.darkGreen,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(!enabled),
    ),
  );
}
