import 'package:flutter/material.dart';
import 'categorias.dart';
import 'habito_conteo.dart';
import 'habito_tiempo.dart';
import 'habito_pendiente.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  // Lista de hábitos
  final List<Map<String, dynamic>> _habits = [
    {
      'name': 'Salir a correr',
      'category': 'Ejercicio',
      'type': 'count',
      'option': 'Al menos',
      'goal': 30,
      'amount': 5,
      'current': 0,
      'description': 'Correr al menos 30 minutos diarios',
      'days': [0, 1, 2, 1, 0, 1, 0], // 0: no registrado, 1: parcial, 2: completado
    },
  ];

  void _showOptionsPopup(BuildContext context, int habitIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pop up hábito',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.green),
                  title: const Text('Editar'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navegar a la pantalla de edición según el tipo de hábito
                    _editHabit(habitIndex);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close, color: Colors.red),
                  title: const Text('Eliminar'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _habits.removeAt(habitIndex);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editHabit(int index) {
    final habit = _habits[index];
    final habitType = habit['type'] ?? 'count'; // Por defecto, asumimos que es de tipo conteo
    
    Widget editScreen;
    
    switch (habitType) {
      case 'count':
        editScreen = HabitoConteoPage(
          category: habit['category'] ?? 'Ejercicio',
          isEditing: true,
          habitData: habit,
        );
        break;
      case 'time':
        editScreen = HabitoTiempoPage(
          category: habit['category'] ?? 'Ejercicio',
          isEditing: true,
          habitData: habit,
        );
        break;
      case 'boolean':
        editScreen = HabitoPendientePage(
          category: habit['category'] ?? 'Ejercicio',
          isEditing: true,
          habitData: habit,
        );
        break;
      default:
        editScreen = HabitoConteoPage(
          category: habit['category'] ?? 'Ejercicio',
          isEditing: true,
          habitData: habit,
        );
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editScreen),
    ).then((updatedHabit) {
      if (updatedHabit != null) {
        setState(() {
          _habits[index] = updatedHabit;
        });
      }
    });
  }

  void _incrementHabit(int index) {
    setState(() {
      if (_habits[index]['current'] < _habits[index]['goal']) {
        _habits[index]['current']++;
        
        // Actualizar el estado del día actual (usamos 0 para domingo, 6 para sábado)
        final today = DateTime.now().weekday % 7; // 0-6 (0 = domingo)
        
        // Determinar el estado basado en el progreso
        if (_habits[index]['current'] >= _habits[index]['goal']) {
          _habits[index]['days'][today] = 2; // Completado (verde)
        } else if (_habits[index]['current'] > 0) {
          _habits[index]['days'][today] = 1; // Parcial (amarillo)
        }
      }
    });
  }

  void _decrementHabit(int index) {
    setState(() {
      if (_habits[index]['current'] > 0) {
        _habits[index]['current']--;
        
        // Actualizar el estado del día actual
        final today = DateTime.now().weekday % 7; // 0-6 (0 = domingo)
        
        // Determinar el estado basado en el progreso
        if (_habits[index]['current'] <= 0) {
          _habits[index]['days'][today] = 0; // No registrado (rojo)
        } else if (_habits[index]['current'] < _habits[index]['goal']) {
          _habits[index]['days'][today] = 1; // Parcial (amarillo)
        }
      }
    });
  }

  void _showRegisterTimeDialog(int index) {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrar Tiempo'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: 180,
                child: Column(
                  children: [
                    const Text('Selecciona el tiempo a registrar:'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Horas
                        Column(
                          children: [
                            const Text('Horas'),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_drop_up),
                                  onPressed: () {
                                    setState(() {
                                      if (hours < 23) hours++;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Text(
                              hours.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 24),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    setState(() {
                                      if (hours > 0) hours--;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Minutos
                        Column(
                          children: [
                            const Text('Minutos'),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_drop_up),
                                  onPressed: () {
                                    setState(() {
                                      if (minutes < 59) minutes++;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Text(
                              minutes.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 24),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    setState(() {
                                      if (minutes > 0) minutes--;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Segundos
                        Column(
                          children: [
                            const Text('Segundos'),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_drop_up),
                                  onPressed: () {
                                    setState(() {
                                      if (seconds < 59) seconds++;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Text(
                              seconds.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 24),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    setState(() {
                                      if (seconds > 0) seconds--;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Actualizar el tiempo del hábito
                final newTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                setState(() {
                  _habits[index]['current'] = newTime;
                  
                  // Actualizar el estado del día actual
                  final today = DateTime.now().weekday % 7;
                  
                  // Determinar el estado basado en el progreso
                  if (hours > 0 || minutes > 0 || seconds > 0) {
                    _habits[index]['days'][today] = 1; // Al menos se registró algo
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        title: const Text(
          'Hábitos',
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
      body: Container(
        color: const Color(0xFFD6F9F0),
        child: _habits.isEmpty
            ? const Center(
                child: Text(
                  'No hay hábitos registrados.\nPresiona el botón + para agregar uno.',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  final habitType = habit['type'] ?? 'count';
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: const Color(0xFFB3E5FC), // Color azul claro
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                habit['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildDayCircle('S', habit['days'][0]),
                                _buildDayCircle('M', habit['days'][1]),
                                _buildDayCircle('T', habit['days'][2]),
                                _buildDayCircle('W', habit['days'][3]),
                                _buildDayCircle('T', habit['days'][4]),
                                _buildDayCircle('F', habit['days'][5]),
                                _buildDayCircle('S', habit['days'][6]),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Mostrar progreso según el tipo de hábito
                              if (habitType == 'count') ...[
                                Text(
                                  '${habit['current']}/${habit['goal']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () => _decrementHabit(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () => _incrementHabit(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () => _showOptionsPopup(context, index),
                                    ),
                                  ],
                                ),
                              ] else if (habitType == 'time') ...[
                                Text(
                                  '${habit['current']}/${habit['goal']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.timer),
                                      onPressed: () => _showRegisterTimeDialog(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () => _showOptionsPopup(context, index),
                                    ),
                                  ],
                                ),
                              ] else if (habitType == 'boolean') ...[
                                Text(
                                  habit['current'] ? 'Completado' : 'Pendiente',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: habit['current'] ? Colors.green : Colors.red,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        habit['current'] ? Icons.check_circle : Icons.check_circle_outline,
                                        color: habit['current'] ? Colors.green : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          habit['current'] = !habit['current'];
                                          
                                          // Actualizar el estado del día actual
                                          final today = DateTime.now().weekday % 7;
                                          habit['days'][today] = habit['current'] ? 2 : 0;
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () => _showOptionsPopup(context, index),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: () {
          // Navegar a la pantalla de selección de categoría
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CategorySelectPage(),
            ),
          ).then((result) {
            // Si hay un resultado (nuevo hábito), agregarlo a la lista
            if (result != null) {
              setState(() {
                _habits.add(result);
              });
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDayCircle(String day, int status) {
    // status: 0 = no registrado (rojo), 1 = parcial (amarillo), 2 = completado (verde)
    Color color;
    switch (status) {
      case 0:
        color = Colors.red;
        break;
      case 1:
        color = Colors.amber;
        break;
      case 2:
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          day,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
