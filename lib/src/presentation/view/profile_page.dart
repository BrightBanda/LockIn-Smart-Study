import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/utils/profile/profile_head.dart';
import 'package:smart_study/src/utils/profile/profile_overview.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
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
                //await Navigator.pushNamed(context, "/loginPage");
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
              }
            },
          ),
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
              streak: "Streak: 🔥15 days",
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
