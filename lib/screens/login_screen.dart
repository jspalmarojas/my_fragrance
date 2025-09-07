import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart'; // Asegúrate de que esta importación esté correcta

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Lógica de inicio de sesión con Firebase
  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Si el inicio de sesión es exitoso, navega a la siguiente pantalla
      // TODO: Implementar navegación a la pantalla de inicio
      print('¡Inicio de sesión exitoso!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No se encontró un usuario con ese correo.');
      } else if (e.code == 'wrong-password') {
        print('Contraseña incorrecta.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyFraganceAI'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Título de la pantalla
              const Text(
                'MyFraganceAI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              // Campo para el correo
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese correo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              // Campo para la contraseña
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              // Botón de iniciar sesión
              ElevatedButton(
                onPressed: signIn, // Llama a la función de inicio de sesión
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 10),
              // Botón para ir a la pantalla de registro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
                child: const Text('¿No tienes una cuenta? Regístrate aquí.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}