import 'package:flutter/material.dart';

class ProfileHead extends StatelessWidget {
  final ImageProvider<Object>? backgroundImage;
  final String? displayName;
  final String? email;
  final Widget? streak;
  const ProfileHead({
    super.key,
    required this.backgroundImage,
    required this.displayName,
    required this.email,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.maxFinite,
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            CircleAvatar(radius: 50, backgroundImage: backgroundImage),
            const SizedBox(height: 16),

            Text(
              displayName ?? 'No name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 2),
                Text(
                  email ?? 'No email',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (streak != null) streak!,
          ],
        ),
      ),
    );
  }
}
