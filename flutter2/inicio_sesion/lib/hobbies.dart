import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'hobbies_info.dart';
import 'hobbies_add.dart';

// Función principal que inicia la aplicación
void main() {
  Intl.defaultLocale = 'es';
  runApp(const MyApp());
}

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hobbies App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4A90E2),
        scaffoldBackgroundColor: const Color.fromRGBO(223, 255, 251, 1),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
        Locale('en', ''),
      ],
      home: const HobbiesPage(),
    );
  }
}

// Página principal de hobbies
class HobbiesPage extends StatefulWidget {
  const HobbiesPage({super.key});

  @override
  State<HobbiesPage> createState() => _HobbiesPageState();
}

// Modificar la clase HobbiesPage para que no tenga navegación en la barra inferior

class _HobbiesPageState extends State<HobbiesPage> {
  
  final List<Map<String, dynamic>> _hobbies = [
    {
      'name': 'Escuchar música',
      'icon': '😊',
      'time': '00:00:00',
    },
    {
      'name': 'Practicar a tocar piano',
      'icon': '😐',
      'time': '00:00:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        title: const Text(
          'Hobbies',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implementar búsqueda
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Búsqueda presionada')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Implementar configuración
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuración presionada')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Lista de Hobbies',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _hobbies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navegar a la pantalla de detalles del hobby
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HobbyInfoPage(
                          hobby: _hobbies[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            _hobbies[index]['icon'],
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _hobbies[index]['name'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            _hobbies[index]['time'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.alarm, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: () {
          // Navegar a la pantalla para agregar un nuevo hobby
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HobbyAddPage(),
            ),
          ).then((newHobby) {
            if (newHobby != null) {
              setState(() {
                _hobbies.add(newHobby);
              });
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // Eliminar el bottomNavigationBar ya que ahora se maneja en MainNavigationPage
    );
  }
}
