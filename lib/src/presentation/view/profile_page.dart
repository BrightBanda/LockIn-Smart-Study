import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/presentation/view/login_page.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/presentation/viewmodel/streakViewmodel.dart';
import 'package:smart_study/src/utils/profile/profile_head.dart';
import 'package:smart_study/src/utils/profile/profile_overview.dart';
import 'package:smart_study/src/utils/resetButton.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final streak = ref.watch(streakProvider);

    if (user == null) {
      //Navigator.pushNamed(context, '/loginPage');
      return LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await ref.read(googleAuthServiceProvider).signOut();
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
              }
            },
          ),
          ResetButton(),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ProfileHead(
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              displayName: user.displayName,
              email: user.email,
              streak: Consumer(
                builder: (context, ref, _) {
                  final streakAsync = ref.watch(streakProvider);

                  return streakAsync.when(
                    loading: () => const Text('🔥 ...'),
                    error: (_, __) => const Text('🔥 0'),
                    data: (streak) => Text(
                      '🔥 ${streak.current} day streak',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            ProfileOverview(),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user.email ?? 'No email'),
            ),
          ],
        ),
      ),
    );
  }
}
