import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/services/google_auth_services.dart';
import 'package:smart_study/src/data/services/user_data_services.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

final userDataServiceProvider = Provider<UserDataServices>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        throw Exception('User not logged in');
      }
      return UserDataServices(uid: user.uid);
    },
    loading: () => throw Exception('Auth loading'),
    error: (_, __) => throw Exception('Auth error'),
  );
});
