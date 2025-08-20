// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dashboard.dart'; // Ensure this contains buildAppDrawer()

class Dietplan extends StatefulWidget {
  const Dietplan({super.key});

  @override
  _DietplanState createState() => _DietplanState();
}

class _DietplanState extends State<Dietplan> {
  late List<List<Map<String, String>>> _weeksData;
  int _currentWeekIndex = 0;
  int _currentDayIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _weeksData = [List.from(_initialDietData)];
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateDietData(int weekIndex, int rowIndex, String key, String value) {
    setState(() {
      _weeksData[weekIndex][rowIndex][key] = value;
    });
  }

  void _addMealTime(int weekIndex) {
    setState(() {
      _weeksData[weekIndex].add({
        'time': 'New Meal',
        'mon': '',
        'tue': '',
        'wed': '',
        'thu': '',
        'fri': '',
        'sat': '',
        'sun': '',
      });
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New meal time added')),
    );
  }

  void _deleteMealTime(int weekIndex, int rowIndex) {
    setState(() {
      _weeksData[weekIndex].removeAt(rowIndex);
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal time deleted')),
    );
  }

  void _reorderMealTimes(int weekIndex, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _weeksData[weekIndex].removeAt(oldIndex);
      _weeksData[weekIndex].insert(newIndex, item);
    });
    HapticFeedback.mediumImpact();
  }

  void _addWeek() {
    setState(() {
      _weeksData.add(List.from(_weeksData[_currentWeekIndex]));
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New week added')),
    );
  }

  void _resetWeek(int weekIndex) {
    setState(() {
      _weeksData[weekIndex] = List.from(_initialDietData);
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Week reset to default')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0F1C),
          foregroundColor: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weekly Diet Plan'),
          actions: [
            DropdownButton<int>(
              value: _currentWeekIndex,
              items: List.generate(_weeksData.length, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text('Week ${index + 1}',
                      style: const TextStyle(color: Colors.white)),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _currentWeekIndex = value!;
                  _currentDayIndex = 0;
                });
              },
              dropdownColor: Colors.black87,
              underline: const SizedBox(),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addWeek,
              tooltip: 'Add Week',
            ),
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: () => _resetWeek(_currentWeekIndex),
              tooltip: 'Reset Week',
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search meals...',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: buildAppDrawer(context),
        body: Column(
          children: [
            CarouselSlider.builder(
              itemCount: _days.length,
              itemBuilder: (context, index, realIndex) {
                bool selected = index == _currentDayIndex;
                return GestureDetector(
                  onTap: () => setState(() => _currentDayIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? const LinearGradient(colors: [Colors.cyan, Colors.purple])
                          : null,
                      color: selected ? null : Colors.white12,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? Colors.cyanAccent : Colors.white24,
                        width: 2,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.5),
                                  blurRadius: 12,
                                  spreadRadius: 1)
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        _days[index],
                        style: TextStyle(
                            color: selected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 60,
                enlargeCenterPage: true,
                viewportFraction: 0.18,
                onPageChanged: (index, reason) => setState(() {
                  _currentDayIndex = index;
                }),
              ),
            ),
            Expanded(
              child: _DayCard(
                day: _days[_currentDayIndex],
                meals: _searchQuery.isEmpty
                    ? _weeksData[_currentWeekIndex]
                    : _weeksData[_currentWeekIndex].where((meal) =>
                        meal[_days[_currentDayIndex].toLowerCase()]!
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase())).toList(),
                onAddMeal: () => _addMealTime(_currentWeekIndex),
                onReorder: (oldIndex, newIndex) =>
                    _reorderMealTimes(_currentWeekIndex, oldIndex, newIndex),
                onUpdateMeal: (rowIndex, value) => _updateDietData(
                    _currentWeekIndex, rowIndex, _days[_currentDayIndex].toLowerCase(), value),
                onDeleteMeal: (rowIndex) => _deleteMealTime(_currentWeekIndex, rowIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- DayCard & MealCard Widgets -------------------

class _DayCard extends StatefulWidget {
  final String day;
  final List<Map<String, String>> meals;
  final VoidCallback onAddMeal;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int rowIndex, String newValue) onUpdateMeal;
  final void Function(int rowIndex) onDeleteMeal;

  const _DayCard({
    required this.day,
    required this.meals,
    required this.onAddMeal,
    required this.onReorder,
    required this.onUpdateMeal,
    required this.onDeleteMeal,
  });

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  late List<bool> _editMode;

  @override
  void initState() {
    super.initState();
    _editMode = List.filled(widget.meals.length, false);
  }

  @override
  void didUpdateWidget(covariant _DayCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.meals.length != _editMode.length) {
      _editMode = List.filled(widget.meals.length, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${widget.day}\'s Meals',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: widget.meals.isEmpty
                  ? const Center(child: Text('No meals found'))
                  : ReorderableListView.builder(
                      itemCount: widget.meals.length,
                      onReorder: widget.onReorder,
                      buildDefaultDragHandles: false,
                      itemBuilder: (context, index) {
                        final meal = widget.meals[index];
                        return _MealCard(
                          key: ValueKey(meal['time']! + index.toString()),
                          time: meal['time']!,
                          mealName: meal[widget.day.toLowerCase()] ?? '',
                          isEditing: _editMode[index],
                          onEditToggle: () {
                            setState(() {
                              _editMode[index] = !_editMode[index];
                            });
                          },
                          onChanged: (value) {
                            widget.onUpdateMeal(index, value);
                          },
                          onDelete: () {
                            widget.onDeleteMeal(index);
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: widget.onAddMeal,
              icon: const Icon(Icons.add),
              label: const Text('Add Meal Time'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCard extends StatefulWidget {
  final String time;
  final String mealName;
  final bool isEditing;
  final VoidCallback onEditToggle;
  final ValueChanged<String> onChanged;
  final VoidCallback onDelete;

  const _MealCard({
    Key? key,
    required this.time,
    required this.mealName,
    required this.isEditing,
    required this.onEditToggle,
    required this.onChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.mealName);
  }

  @override
  void didUpdateWidget(covariant _MealCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mealName != oldWidget.mealName && !widget.isEditing) {
      _controller.text = widget.mealName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: widget.key,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Text(
            widget.time,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        title: widget.isEditing
            ? TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter meal name',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  widget.onChanged(value);
                  widget.onEditToggle();
                },
              )
            : Text(
                widget.mealName.isEmpty ? 'No meal set' : widget.mealName,
                style: const TextStyle(fontSize: 16),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(widget.isEditing ? Icons.check : Icons.edit,
                  color: widget.isEditing ? Colors.green : Colors.indigo),
              onPressed: () {
                if (widget.isEditing) widget.onChanged(_controller.text);
                widget.onEditToggle();
              },
              tooltip: widget.isEditing ? 'Save' : 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: widget.onDelete,
              tooltip: 'Delete meal',
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- Sample Data -------------------
final List<Map<String, String>> _initialDietData = [
  {
    'time': '7am',
    'mon': 'Oats with berries',
    'tue': 'Egg white omelette',
    'wed': 'Smoothie bowl',
    'thu': 'Greek yogurt & nuts',
    'fri': 'Fruit salad',
    'sat': 'Protein pancakes',
    'sun': 'Avocado toast',
  },
  {
    'time': '10am',
    'mon': 'Apple & peanut butter',
    'tue': 'Trail mix',
    'wed': 'Boiled eggs',
    'thu': 'Carrot sticks',
    'fri': 'Protein bar',
    'sat': 'Mixed nuts',
    'sun': 'Yogurt parfait',
  },
  {
    'time': '1pm',
    'mon': 'Grilled chicken salad',
    'tue': 'Turkey sandwich',
    'wed': 'Quinoa & veggies',
    'thu': 'Tuna wrap',
    'fri': 'Lentil soup',
    'sat': 'Chicken stir fry',
    'sun': 'Veggie pasta',
  },
  {
    'time': '4pm',
    'mon': 'Hummus & celery',
    'tue': 'Protein shake',
    'wed': 'Cottage cheese',
    'thu': 'Almonds',
    'fri': 'Fruit smoothie',
    'sat': 'Boiled eggs',
    'sun': 'Mixed berries',
  },
  {
    'time': '7pm',
    'mon': 'Salmon & broccoli',
    'tue': 'Steak & salad',
    'wed': 'Chicken curry',
    'thu': 'Veggie stir fry',
    'fri': 'Shrimp & quinoa',
    'sat': 'Beef & vegetables',
    'sun': 'Grilled fish & rice',
  },
];
