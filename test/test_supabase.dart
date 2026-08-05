import 'package:flutter/foundation.dart';
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
      debugPrint('Fetched ${responseMeal.length} meals.');
      
      int parsedCount = 0;
      for (var row in responseMeal) {
        try {
          final meal = MealModel.fromJson(row);
          expect(meal, isNotNull);
          parsedCount++;
        } catch (e) {
          debugPrint('Failed to parse row: $row');
          debugPrint('Error: $e');
        }
      }
      debugPrint('Successfully parsed $parsedCount / ${responseMeal.length} meals.');
    } catch (e) {
      debugPrint('Query error: $e');
    }
  });
}
