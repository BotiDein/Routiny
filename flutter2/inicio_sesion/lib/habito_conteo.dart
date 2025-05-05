import 'package:flutter/material.dart';

class HabitoConteoPage extends StatefulWidget {
  final String category;
  final bool isEditing;
  final Map<String, dynamic>? habitData;
  
  const HabitoConteoPage({
    super.key,
    required this.category,
    this.isEditing = false,
    this.habitData,
  });

  @override
  State<HabitoConteoPage> createState() => _HabitoConteoPageState();
}

class _HabitoConteoPageState extends State<HabitoConteoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _selectedOption = 'Al menos';
  bool _isGoalEnabled = true;
  
  final List<String> _options = [
    'Al menos',
    'Marca de',
    'Exactamente',
    'Sin objetivo',
  ];

  @override
  void initState() {
    super.initState();
    
    // Si estamos editando, cargar los datos del hábito
    if (widget.isEditing && widget.habitData != null) {
      _titleController.text = widget.habitData!['name'] ?? '';
      _goalController.text = widget.habitData!['goal']?.toString() ?? '';
      _amountController.text = widget.habitData!['amount']?.toString() ?? '';
      _descriptionController.text = widget.habitData!['description'] ?? '';
      _selectedOption = widget.habitData!['option'] ?? 'Al menos';
      _isGoalEnabled = _selectedOption != 'Sin objetivo';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _goalController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.isEditing ? 'Editar hábito por conteo' : 'Nuevo hábito por conteo',
          style: const TextStyle(
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
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE0FFFF), // Fondo azul claro
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF4A90E2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Text(
                'Registrar progreso',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categoría
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.category,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Título
                    const Text(
                      'Título',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Texto',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Opciones y cantidad
                    Row(
                      children: [
                        // Dropdown de opciones
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedOption,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: _options.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedOption = newValue!;
                                      _isGoalEnabled = newValue != 'Sin objetivo';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Campo de cantidad
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Cantidad en el día',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Objetivo
                    const Text(
                      'Objetivo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _goalController,
                      enabled: _isGoalEnabled,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Tu objetivo final\nEj: 145 páginas',
                        filled: true,
                        fillColor: _isGoalEnabled 
                            ? Colors.white.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Descripción
                    const Text(
                      'Descripción:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Describe tu nuevo hábito.',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                      // Validar y guardar el hábito
                      if (_titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor ingresa un título')),
                        );
                        return;
                      }
                      
                      if (_isGoalEnabled && _goalController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor ingresa un objetivo')),
                        );
                        return;
                      }
                      
                      // Crear el hábito y volver
                      final newHabit = {
                        'name': _titleController.text,
                        'category': widget.category,
                        'type': 'count',
                        'option': _selectedOption,
                        'goal': _isGoalEnabled ? int.tryParse(_goalController.text) ?? 0 : 0,
                        'amount': int.tryParse(_amountController.text) ?? 0,
                        'description': _descriptionController.text,
                        'current': 0,
                        'days': [0, 0, 0, 0, 0, 0, 0],
                      };
                      
                      Navigator.pop(context, newHabit);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 45),
                    ),
                    child: Text(
                      widget.isEditing ? 'Guardar' : 'Crear',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
