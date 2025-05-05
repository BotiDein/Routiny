import 'package:flutter/material.dart';
import 'habitos_select_seguimiento.dart';
import 'categoria_add.dart';

class CategorySelectPage extends StatefulWidget {
  const CategorySelectPage({super.key});

  @override
  State<CategorySelectPage> createState() => _CategorySelectPageState();
}

class _CategorySelectPageState extends State<CategorySelectPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  
  // Lista de categorías predefinidas
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Ejercicio', 'icon': '⚡'},
    {'name': 'Salud', 'icon': '❤️'},
    {'name': 'Educación', 'icon': '👍'},
    {'name': 'Trabajo', 'icon': '😊'},
    {'name': 'Lorem', 'icon': '➕'},
    {'name': 'Ipsum', 'icon': '➕'},
    {'name': 'Dolor', 'icon': '➕'},
    {'name': 'Sit', 'icon': '➕'},
    {'name': 'Amet', 'icon': '➕'},
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchController.text.isEmpty) {
      return _categories;
    }
    
    return _categories.where((category) => 
      category['name'].toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  void _showNewCategoryDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const NewCategoryDialog(),
    );
    
    if (result != null) {
      setState(() {
        _categories.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Seleccionar categoría',
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
      backgroundColor: Color(0xFF4A90E2),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF4A90E2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar categoría',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _showNewCategoryDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFD6F9F0),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = _filteredCategories[index];
                  final isSelected = _selectedCategory == category['name'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category['name'];
                      });
                    },
                    child: Container(
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
                          Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                category['icon'],
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              category['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (category['name'] == 'Lorem' || 
                              category['name'] == 'Ipsum' || 
                              category['name'] == 'Dolor' || 
                              category['name'] == 'Sit' || 
                              category['name'] == 'Amet')
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, size: 20),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFFD6F9F0),
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
                onPressed: _selectedCategory != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HabitTypeSelectPage(
                              category: _selectedCategory!,
                            ),
                          ),
                        ).then((result) {
                          // Si hay un resultado (nuevo hábito), pasarlo a la pantalla anterior
                          if (result != null) {
                            Navigator.pop(context, result);
                          }
                        });
                      }
                    : null,
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
  );
  }
}