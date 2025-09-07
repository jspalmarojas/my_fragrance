import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>?>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _fetchUserData() async {
    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    }
    return null;
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                const Text(
                  'MyFragranceAI',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 40),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mi Perfil',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: signUserOut,
                              icon: const Icon(Icons.logout),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                          future: _userDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                              return const Text('No se encontraron datos del usuario.');
                            }

                            final userData = snapshot.data!.data();
                            final userEmail = userData?['email'] ?? 'Sin correo';

                            return Column(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.deepPurple,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Bienvenido a tu perfil',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Correo: $userEmail',
                                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}