import 'package:flutter/material.dart';
import 'meal_card.dart';
import 'meal.dart';
import 'meal.api.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final TextEditingController _searchController = TextEditingController();
  Recipe? _recipe;
  double _totalCalories = 0.0;
  double _totalProtein = 0.0;

  void _search(String query) async {
    try {
      final Map<String, dynamic> nutritionData = await MealApi.fetchNutritionInfo(query);
      setState(() {
        _recipe = Recipe.fromJson(nutritionData);
        _updateTotalValues(_recipe!);
      });
    } catch (e) {
      print('Error fetching nutrition info: $e');
      // Handle error, e.g., display an error message to the user
    }
  }

  void _updateTotalValues(Recipe recipe) {
    setState(() {
      _totalCalories += recipe.calories;
      _totalProtein += recipe.protein_g;
    });
  }

  void _addCaloriesAndProtein(double calories, double protein) {
    setState(() {
      _totalCalories += calories;
      _totalProtein += protein;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_rounded),
            SizedBox(width: 10),
            Text('Meal'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter query...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _search(_searchController.text),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Background color of the search bar
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Padding inside the search bar
                ),
                onSubmitted: _search,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularProgressBar('Total Calories', _totalCalories, 2000),
                _buildCircularProgressBar('Total Protein (g)', _totalProtein, 50),
              ],
            ),
            SizedBox(height: 20),
            if (_recipe != null)
              RecipeCard(
                // Pass recipe details as parameters
                recipe: _recipe!,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addCaloriesAndProtein(100.0, 10.0); // Example values, you can adjust them as needed
              },
              child: Text('Add Meal'),
            ),
            // Add additional widgets here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgressBar(String label, double value, double max) {
    double progress = value / max;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
                  strokeWidth: 15,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '$value / $max',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
