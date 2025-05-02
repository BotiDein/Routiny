import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  final Map<String, dynamic> hobby;

  const StopwatchPage({
    super.key,
    required this.hobby,
  });

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  // Estados del cronómetro
  bool _isRunning = false;
  bool _isPaused = false;
  
  // Variables para el cronómetro
  Stopwatch _stopwatch = Stopwatch();
  String _elapsedTime = "00:00.00";
  Timer? _timer;
  
  // Lista de checkpoints
  final List<String> _checkpoints = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Iniciar el cronómetro
  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _stopwatch.start();
      
      // Actualizar el tiempo cada 10 milisegundos
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (_stopwatch.isRunning) {
          setState(() {
            _elapsedTime = _formatTime(_stopwatch.elapsedMilliseconds);
          });
        }
      });
    });
  }

  // Pausar el cronómetro
  void _pauseStopwatch() {
    setState(() {
      _isPaused = true;
      _stopwatch.stop();
    });
  }

  // Reanudar el cronómetro
  void _resumeStopwatch() {
    setState(() {
      _isPaused = false;
      _stopwatch.start();
    });
  }

  // Detener y reiniciar el cronómetro
  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _stopwatch.stop();
      _stopwatch.reset();
      _elapsedTime = "00:00.00";
      _checkpoints.clear();
      _timer?.cancel();
    });
  }

  // Añadir un checkpoint
  void _addCheckpoint() {
    setState(() {
      _checkpoints.insert(0, _elapsedTime); // Insertar al inicio para mostrar el más reciente primero
    });
  }

  // Formatear el tiempo en milisegundos a formato MM:SS.CC
  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds ~/ 10) % 100;
    int seconds = (milliseconds ~/ 1000) % 60;
    int minutes = (milliseconds ~/ 60000) % 60;
    
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${hundreds.toString().padLeft(2, '0')}";
  }

  // Guardar el tiempo total y volver a la pantalla anterior
  void _saveAndGoBack() {
    // Aquí podrías implementar la lógica para guardar el tiempo total
    Navigator.pop(context, _elapsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2), // Verde oscuro para el cronómetro
        title: Text(
          _isRunning 
            ? (_isPaused ? "Cronómetro pausado" : "Cronómetro empezado") 
            : "Cronómetro sin empezar",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Preguntar si desea guardar el tiempo antes de salir
            if (_isRunning) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Guardar tiempo?'),
                  content: const Text('¿Deseas guardar el tiempo registrado?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar diálogo
                        Navigator.pop(context); // Volver sin guardar
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar diálogo
                        _saveAndGoBack(); // Guardar y volver
                      },
                      child: const Text('Sí'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // Tiempo del cronómetro
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  _elapsedTime,
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Botones de control
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isRunning) ...[
                    // Botón de inicio
                    _buildCircleButton(
                      onPressed: _startStopwatch,
                      icon: Icons.play_arrow,
                      color: Colors.blue,
                    ),
                  ] else if (!_isPaused) ...[
                    // Botón de checkpoint
                    _buildCircleButton(
                      onPressed: _addCheckpoint,
                      icon: Icons.flag,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 40),
                    // Botón de pausa
                    _buildCircleButton(
                      onPressed: _pauseStopwatch,
                      icon: Icons.pause,
                      color: Colors.blue,
                    ),
                  ] else ...[
                    // Botón de detener
                    _buildCircleButton(
                      onPressed: _resetStopwatch,
                      icon: Icons.stop,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 40),
                    // Botón de reanudar
                    _buildCircleButton(
                      onPressed: _resumeStopwatch,
                      icon: Icons.play_arrow,
                      color: Colors.blue,
                    ),
                  ],
                ],
              ),
            ),
            
            // Lista de checkpoints
            if (_checkpoints.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Checkpoints',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: _checkpoints.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'Checkpoint ${index + 1}: ${_checkpoints[index]}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            
            // Botón para guardar el tiempo total
            if (_isRunning || _elapsedTime != "00:00.00") ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _saveAndGoBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(7, 134, 45, 20),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Guardar tiempo total',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.2),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color,
          size: 30,
        ),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
