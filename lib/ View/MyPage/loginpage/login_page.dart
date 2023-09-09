// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'login_auth.dart';

// class LoginPage extends ConsumerWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   LoginPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authService = ref.read(authStateProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Log in'),
//       ),
//       body: Column(
//         children: <Widget>[
//           TextField(
//             controller: _emailController,
//             decoration: const InputDecoration(labelText: 'Email'),
//           ),
//           TextField(
//             controller: _passwordController,
//             decoration: const InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ),
//           ElevatedButton(
//             child: const Text('Log in'),
//             onPressed: () async {
//               try {
//                 await authService.signIn(
//                     _emailController.text, _passwordController.text);
//                 // Navigate to the next screen if sign in succeeded
//                 Navigator.pushNamed(context, '/nextScreen');
//               } catch (e) {
//                 print(e);
//                 // Show error message if sign in failed
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Failed to log in')),
//                 );
//               }
//             },
//           ),
//           ElevatedButton(
//             child: const Text('Sign up'),
//             onPressed: () async {
//               try {
//                 await authService.signUp(
//                     _emailController.text, _passwordController.text);
//                 // Navigate to the next screen if sign up succeeded
//                 Navigator.pushNamed(context, '/nextScreen');
//               } catch (e) {
//                 print(e);
//                 // Show error message if sign up failed
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Failed to sign up')),
//                 );
//               }
//             },
//           ),
//           ElevatedButton(
//             child: const Text('Log out'),
//             onPressed: () async {
//               try {
//                 await authService.signOut();
//                 // Show a success message and possibly navigate to a different screen
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Logged out successfully')),
//                 );
//               } catch (e) {
//                 print(e);
//                 // Show error message if log out failed
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Failed to log out')),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
