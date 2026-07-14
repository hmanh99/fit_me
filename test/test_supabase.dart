import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:personal_fitness_tracker/features/meal/data/models/meal_model.dart';

void main() {
  test('Inspect Supabase meals parsing', () async {
    await Supabase.initialize(
      url: 'https://rrwpymefmyqnxeeithst.supabase.co',
      anonKey: 'sb_publishable_mK5OJp-IdJ3q1r1xR9-78w_rb6v1ELz',
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );

    final client = Supabase.instance.client;

    try {
      final responseMeal = await client.from('meal').select();
      print('Fetched ${responseMeal.length} meals.');
      
      int parsedCount = 0;
      for (var row in responseMeal) {
        try {
          final meal = MealModel.fromJson(row);
          parsedCount++;
        } catch (e) {
          print('Failed to parse row: $row');
          print('Error: $e');
        }
      }
      print('Successfully parsed $parsedCount / ${responseMeal.length} meals.');
    } catch (e) {
      print('Query error: $e');
    }
  });
}
