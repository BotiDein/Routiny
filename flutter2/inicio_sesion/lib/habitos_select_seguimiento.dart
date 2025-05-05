import 'package:flutter/material.dart';
import 'habito_conteo.dart';
import 'habito_tiempo.dart';
import 'habito_pendiente.dart';

class HabitTypeSelectPage extends StatefulWidget {
  final String category;
  
  const HabitTypeSelectPage({
    super.key,
    required this.category,
  });

  @override
  State<HabitTypeSelectPage> createState() => _HabitTypeSelectPageState();
}

class _HabitTypeSelectPageState extends State<HabitTypeSelectPage> {
  String _selectedType = 'count'; // 'count', 'time', 'boolean'
  
  void _showInfoDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHabitCreation() {
    switch (_selectedType) {
      case 'count':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitoConteoPage(
              category: widget.category,
            ),
          ),
        ).then((result) {
          if (result != null) {
            // Volver a la pantalla de hábitos con el nuevo hábito
            Navigator.pop(context, result);
          }
        });
        break;
      case 'time':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitoTiempoPage(
              category: widget.category,
            ),
          ),
        ).then((result) {
          if (result != null) {
            // Volver a la pantalla de hábitos con el nuevo hábito
            Navigator.pop(context, result);
          }
        });
        break;
      case 'boolean':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitoPendientePage(
              category: widget.category,
            ),
          ),
        ).then((result) {
          if (result != null) {
            // Volver a la pantalla de hábitos con el nuevo hábito
            Navigator.pop(context, result);
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Nuevo hábito',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        color: const Color(0xFFD6F9F0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF4A90E2),
              child: const Text(
                'Registrar progreso',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.assignment,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 32),
                    
                    // Opción por conteo
                    _buildTypeOption(
                      'Por conteo',
                      Icons.add_circle_outline,
                      'count',
                      'Registro por conteo',
                      'El registro por conteo te permite llevar tu progreso por un contador personalizado. Por ejemplo: Comer 5 manzanas diarias.',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Opción por tiempo
                    _buildTypeOption(
                      'Por tiempo',
                      Icons.timer_outlined,
                      'time',
                      'Registro por tiempo',
                      'Registro por conteo de tiempo que llevó la tarea a realizarse o el tiempo que estuve en esa tarea.',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Opción hecho/pendiente
                    _buildTypeOption(
                      'Hecho o pendiente',
                      Icons.check_circle_outline,
                      'boolean',
                      'Registro hecho/pendiente',
                      'Registro de una tarea de si está hecha o no (Sí o No).',
                    ),
                  ],
                ),
              ),
            ),
            
            // Botones inferiores
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 45),
                    ),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToHabitCreation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 45),
                    ),
                    child: const Text('Siguiente'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(
    String title, 
    IconData icon, 
    String type, 
    String dialogTitle, 
    String dialogDescription
  ) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.help_outline, size: 20),
              color: Colors.blue,
              onPressed: () {
                _showInfoDialog(dialogTitle, dialogDescription);
              },
            ),
          ],
        ),
      ),
    );
  }
}
