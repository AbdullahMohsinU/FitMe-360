// ignore_for_file: deprecated_member_use, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart'; // Haptic feedback
import 'package:google_fonts/google_fonts.dart';
import 'dashboard.dart'; // Drawer

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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.9, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: FlipCard(
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          onFlip: () => HapticFeedback.selectionClick(),
          front: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0A0F1C), Color(0xFF121826)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF00E5FF),
                  blurRadius: 12,
                  spreadRadius: 1,
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
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00E5FF),
                          shadows: [
                            const Shadow(
                              color: Color(0xFF00E5FF),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.flip_to_back,
                          color: Colors.pinkAccent,
                          size: 26,
                          shadows: const [
                            Shadow(
                              color: Color(0xFFFF00FF),
                              blurRadius: 8,
                            )
                          ],
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
              gradient: const LinearGradient(
                colors: [Color(0xFF121826), Color(0xFF0A0F1C)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFFF00FF),
                  blurRadius: 12,
                  spreadRadius: 1,
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
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF00FF),
                      shadows: const [
                        Shadow(
                          color: Color(0xFFFF00FF),
                          blurRadius: 12,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    backDescription,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.flip_to_front,
                      color: Colors.cyanAccent,
                      size: 26,
                      shadows: const [
                        Shadow(
                          color: Color(0xFF00E5FF),
                          blurRadius: 8,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1C),
      ),
      child: Scaffold(
        drawer: buildAppDrawer(context),
        appBar: AppBar(
          title: const Text(
            'SPECIFIC DIET-PLAN',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(color: Color(0xFF00E5FF), blurRadius: 12),
              ],
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [Color(0xFF00E5FF), Color(0xFFFF00FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            labelStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelColor: Colors.white54,
            labelColor: Colors.white,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            onTap: (_) => HapticFeedback.lightImpact(),
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
            HapticFeedback.mediumImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Save your favorite tips!')),
            );
          },
          backgroundColor: const Color(0xFF00E5FF),
          child: const Icon(Icons.bookmark_border, color: Colors.white),
        ),
      ),
    );
  }
}
