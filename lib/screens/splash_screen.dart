import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Importación de la pantalla de inicio de sesión
import 'profile_screen.dart'; // Importación de la pantalla de perfil

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en el estado de autenticación de Firebase
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Muestra un indicador de carga mientras verifica la conexión
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Si hay un usuario autenticado, navega a la pantalla de perfil
        if (snapshot.hasData) {
          return const ProfileScreen();
        } else {
          // Si no hay usuario autenticado, navega a la pantalla de inicio de sesión
          return const LoginScreen();
        }
      },
    );
  }
}
