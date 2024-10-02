import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/widgets/category_grid_item.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/catergory.dart';
import 'package:meals/models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategories.asMap().entries)
          AnimatedBuilder(
            animation: _animationController,
            child: CategoryGridItem(
              category: category.value,
              onSelectedCategory: () {
                _selectCategory(context, category.value);
              },
            ),
            builder: (context, child) {
              final rowIndex = category.key ~/ 2;
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3), // Reduced initial offset
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      (rowIndex / (availableCategories.length / 2)) *
                          0.6, // Adjusted interval
                      ((rowIndex + 1) / (availableCategories.length / 2)) *
                              0.6 +
                          0.4, // Overlap animations
                      curve: Curves.easeOutCubic, // Changed curve
                    ),
                  ),
                ),
                child: FadeTransition(
                  // Added fade transition
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        (rowIndex / (availableCategories.length / 2)) * 0.6,
                        ((rowIndex + 1) / (availableCategories.length / 2)) *
                                0.6 +
                            0.4,
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  child: child!,
                ),
              );
            },
          ),
      ],
    );
  }
}
