import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inicio_sesion/confi.dart';

//Se asegura de que la app solo se ejecute en orientación vertical.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const Menu());
  });
}

// Widget raíz de la aplicación que configura el tema y la pantalla inicial.
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF4A90E2),
        scaffoldBackgroundColor: const Color(0xFFE0FFFF),
        useMaterial3: true,
      ),
      home: const InicioApp(),
    );
  }
}

// Widget principal con navegación inferior y contenido dinámico por página.
class InicioApp extends StatefulWidget {
  const InicioApp({super.key});

  @override
  State<InicioApp> createState() => _InicioAppState();
}

class _InicioAppState extends State<InicioApp> {
  int _selectedIndex = 2;

  // Títulos de cada página para mostrar en AppBar.
  final List<String> _pageTitles = [
    'Hábitos',
    'Agenda',
    'Inicio',
    'Calendario',
    'Hobbies',
  ];

  // Cambia el índice seleccionado al presionar un ítem de navegación.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Escalado dinámico para responsividad.
    final horizontalPadding = screenWidth * 0.04;
    final titleFontSize = screenWidth * 0.06;
    final smallFontSize = screenWidth * 0.035;
    final largeIconSize = screenWidth * 0.06;
    final navBarHeight = screenHeight * 0.08;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        title: Text(
          _pageTitles[_selectedIndex],
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: titleFontSize,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: largeIconSize, color: Colors.black),
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConfiguracionScreen()),
              );
            }, // Acción de configuración futura.
          ),
          SizedBox(width: horizontalPadding / 2),
        ],
      ),
      body: _buildBodyContent(context),
      bottomNavigationBar: _buildBottomNavBar(screenWidth, smallFontSize, navBarHeight),
    );
  }

  // Construye la barra de navegación inferior con ítems personalizados.
  Widget _buildBottomNavBar(double screenWidth, double fontSize, double height) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF4A90E2),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.trending_up, 'Hábitos', screenWidth, fontSize),
              _buildNavItem(1, Icons.book, 'Agenda', screenWidth, fontSize),
              _buildNavItem(2, Icons.home, 'Inicio', screenWidth, fontSize),
              _buildNavItem(3, Icons.calendar_today, 'Calendario', screenWidth, fontSize),
              _buildNavItem(4, Icons.sports_esports, 'Hobbies', screenWidth, fontSize),
            ],
          ),
        ),
      ),
    );
  }

  // Ítem individual de la barra de navegación.
  Widget _buildNavItem(int index, IconData icon, String label, double screenWidth, double fontSize) {
    final bool isSelected = _selectedIndex == index;
    final itemWidth = screenWidth * 0.18;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: itemWidth,
        padding: EdgeInsets.symmetric(vertical: fontSize * 0.3),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF81B4F9) : Colors.transparent,
          borderRadius: BorderRadius.circular(fontSize * 0.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: fontSize * 1.5),
            SizedBox(height: fontSize * 0.2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
                fontSize: fontSize * 0.9,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Contenido principal de la página "Inicio" y placeholder para otras páginas.
  Widget _buildBodyContent(BuildContext context) {
    if (_selectedIndex != 2) {
      return const Center(
        child: Text('Contenido no disponible aún'),
      );
    }

    // Funciones para escalar medidas en pantallas diferentes.
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double scaleWidth(double value) => value * screenWidth / 720;
    double scaleHeight(double value) => value * screenHeight / 1280;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: scaleHeight(20)),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: scaleHeight(40)),

            // Tarjeta: Próximas tareas a realizar
            Container(
              width: scaleWidth(486),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0052A9), width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: scaleHeight(93),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5499E3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Próximas tareas a realizar',
                      style: TextStyle(
                        fontSize: scaleHeight(24),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(scaleWidth(16)),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB3FFFF),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: scaleHeight(8)),
                        Text(
                          'Tareas para hoy',
                          style: TextStyle(
                            fontSize: scaleHeight(35),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: scaleHeight(8)),
                        // Lista de tareas ficticias
                        ...List.generate(
                          5,
                          (i) => Text(
                            '• Tarea ${i + 1}',
                            style: TextStyle(
                              fontSize: scaleHeight(28),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: scaleHeight(16)),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Mostrar más',
                            style: TextStyle(
                              fontSize: scaleHeight(20),
                              color: const Color(0xFF0052A9),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: scaleHeight(29)),

            // Tarjeta: Tareas por fecha (estática por ahora)
            Container(
              width: scaleWidth(486),
              height: scaleHeight(280),
              decoration: BoxDecoration(
                color: const Color(0xFFB3FFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0052A9), width: 1),
              ),
              padding: EdgeInsets.all(scaleWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(fecha 10/04/2025)',
                    style: TextStyle(
                      fontSize: scaleHeight(35),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: scaleHeight(8)),
                  Text(
                    '• Tarea 1',
                    style: TextStyle(
                      fontSize: scaleHeight(28),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '• Tarea 2',
                    style: TextStyle(
                      fontSize: scaleHeight(28),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Mostrar más',
                      style: TextStyle(
                        fontSize: scaleHeight(20),
                        color: const Color(0xFF0052A9),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: scaleHeight(50)),

            // Botón para ver el resumen personal
            SizedBox(
              width: scaleWidth(382),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052A9),
                  padding: EdgeInsets.symmetric(vertical: scaleHeight(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {}, // Acción pendiente para el resumen
                child: Text(
                  'VER RESUMEN PERSONAL',
                  style: TextStyle(
                    fontSize: scaleHeight(24),
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: scaleHeight(30)),
          ],
        ),
      ),
    );
  }
}
