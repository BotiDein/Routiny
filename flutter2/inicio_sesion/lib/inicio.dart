import 'dart:async';
import 'package:flutter/material.dart';
import 'menu.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    super.initState();
    // Espera 3 segundos antes de navegar a la pantalla del menú principal
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Menu()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla para usar medidas proporcionales
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFDFFFFB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png',
              width: screenWidth * 0.6,
              height: screenHeight * 0.3,
            ),
            SizedBox(height: screenHeight * 0.04),
            const Text(
              'Routiny',
              style: TextStyle(
                fontFamily: 'RobotoBold',
                fontSize: 48,
                color: Color(0xFF0052A9),
              ),
            ),
            SizedBox(height: screenHeight * 0.18),
            // Indicador de carga
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0052A9)),
            ),
          ],
        ),
      ),
    );
  }
}
