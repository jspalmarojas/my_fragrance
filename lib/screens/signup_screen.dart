import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore
import 'login_screen.dart';
import 'profile_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signUp() async {
    try {
      // Intenta crear el usuario en Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Si el registro es exitoso, crea un documento en Firestore para el usuario
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid) // Usa el UID del usuario como ID del documento
            .set({
          'email': userCredential.user!.email,
          'createdAt': FieldValue.serverTimestamp(),
          // Puedes agregar más campos de usuario aquí, como 'username' o 'name'
        });
      }

      // Navega a la pantalla de perfil después del registro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
      print('¡Registro exitoso!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña proporcionada es muy débil.');
      } else if (e.code == 'email-already-in-use') {
        print('Ya existe una cuenta para ese correo.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyFraganceAI - Registro'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Crear una cuenta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese correo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: signUp,
                child: const Text('Registrarse'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('¿Ya tienes una cuenta? Inicia sesión aquí.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
