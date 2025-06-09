import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dashboard.dart'; // Import for drawer

class SpecificDietPlan extends StatefulWidget {
  const SpecificDietPlan({super.key});

  @override
  State<SpecificDietPlan> createState() => _SpecificDietPlanState();
}

class _SpecificDietPlanState extends State<SpecificDietPlan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'Healthy Foods',
    'Health Tips',
    'Nutrition Facts',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildInfoCard(String image, String title, String description, String backDescription) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.HORIZONTAL,
        front: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade100, Colors.orange.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.flip_to_back,
                        color: Colors.orange.shade700,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'More About $title',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  backDescription,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.flip_to_front,
                    color: Colors.orange.shade700,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: buildAppDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'SPECIFIC DIET-PLAN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.orange.shade300,
          ),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelColor: Colors.grey.shade600,
          labelColor: Colors.white,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Healthy Foods
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              buildInfoCard(
                'assets/content/mango.jpg',
                'Sweet Mango',
                'Mangoes are rich in vitamin C and antioxidants, boosting immunity.',
                'Mangoes contain enzymes like amylases that aid digestion.',
              ),
              buildInfoCard(
                'assets/content/oats.jpg',
                'Oatmeal',
                'Oats are packed with fiber, supporting heart health and energy.',
                'Beta-glucan in oats helps lower cholesterol levels.',
              ),
            ],
          ),

          // Health Tips
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              buildInfoCard(
                'assets/content/liver.jpg',
                'Liver Care',
                'Beets and leafy greens support liver detoxification.',
                'Cruciferous vegetables like broccoli boost liver enzyme production.',
              ),
              buildInfoCard(
                'assets/content/malaria.jpg',
                'Stay Strong',
                'Hydration and nutrient-rich fruits aid recovery.',
                'Vitamin A from fruits strengthens your immune system.',
              ),
            ],
          ),

          // Nutrition Facts
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              buildInfoCard(
                'assets/content/mango.jpg',
                'Mango Nutrition',
                'Mangoes provide over 60% of daily vitamin C needs.',
                'Rich in dietary fiber, mangoes promote gut health.',
              ),
              buildInfoCard(
                'assets/content/oats.jpg',
                'Oats Nutrition',
                'Oats are a great source of soluble fiber for digestion.',
                'Contains manganese, essential for bone health.',
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Save your favorite tips!')),
          );
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.bookmark_border),
      ),
    );
  }
}