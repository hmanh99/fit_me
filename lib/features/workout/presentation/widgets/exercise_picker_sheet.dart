import 'package:easy_localization/easy_localization.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/di/injection_container.dart' as di;
import 'package:fit_me/core/services/exercise_services.dart';
import 'package:flutter/material.dart';

class ExercisePickerSheet extends StatefulWidget {
  final List<int> alreadySelectedIds;
  final ExerciseServices? exerciseServices;

  const ExercisePickerSheet({
    super.key,
    this.alreadySelectedIds = const [],
    this.exerciseServices,
  });

  static Future<List<Map<String, dynamic>>?> show(
    BuildContext context, {
    List<int> alreadySelectedIds = const [],
    ExerciseServices? exerciseServices,
  }) {
    return showModalBottomSheet<List<Map<String, dynamic>>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ExercisePickerSheet(
          alreadySelectedIds: alreadySelectedIds,
          exerciseServices: exerciseServices,
        );
      },
    );
  }

  @override
  State<ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<ExercisePickerSheet> {
  late final ExerciseServices _exerciseServices;
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedIds = {};
  final Map<int, Map<String, dynamic>> _selectedEntities = {};
  String _selectedMuscleGroup = 'all';
  String _searchQuery = '';

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _exercises = [];

  final List<String> _muscleGroupKeys = [
    'all'.tr(),
    'chest'.tr(),
    'back'.tr(),
    'shoulders'.tr(),
    'arms'.tr(),
    'legs'.tr(),
    'core'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.exerciseServices != null) {
      _exerciseServices = widget.exerciseServices!;
    } else if (di.serviceLocator.isRegistered<ExerciseServices>()) {
      _exerciseServices = di.serviceLocator<ExerciseServices>();
    } else {
      _exerciseServices = ExerciseServices();
    }

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });

    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _exerciseServices.getAllExercises();
      if (mounted) {
        setState(() {
          _exercises = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      margin: EdgeInsets.only(bottom: bottomPadding),
      decoration: const BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 8),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorConstants.greyShade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'select_exercises'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.textPrimaryColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: ColorConstants.greyShade600,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'search_exercise_hint'.tr(),
                hintStyle: const TextStyle(color: ColorConstants.greyShade500, fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: ColorConstants.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: ColorConstants.greyShade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Muscle Group Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _muscleGroupKeys.map((groupKey) {
                final isSelected = _selectedMuscleGroup.toLowerCase() == groupKey.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      groupKey.tr(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? ColorConstants.white : ColorConstants.textPrimaryColor,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: ColorConstants.primaryColor,
                    backgroundColor: ColorConstants.greyShade100,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedMuscleGroup = groupKey;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1, color: ColorConstants.borderLightColor),

          // Exercise List
          Expanded(
            child: _buildBody(),
          ),

          // Bottom Action Button
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: ColorConstants.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstants.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedIds.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop(_selectedEntities.values.toList());
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.buttonColor,
                    foregroundColor: ColorConstants.buttonTextColor,
                    disabledBackgroundColor: ColorConstants.greyShade300,
                    disabledForegroundColor: ColorConstants.greyShade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _selectedIds.isEmpty
                        ? 'select_exercises_btn'.tr()
                        : 'add_selected_count'.tr(
                            namedArgs: {'count': _selectedIds.length.toString()},
                          ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ColorConstants.errorColor),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchExercises,
              child: Text('retry'.tr()),
            ),
          ],
        ),
      );
    }

    var filtered = _exercises;

    // Filter by muscle group
    if (_selectedMuscleGroup.toLowerCase() != 'all') {
      filtered = filtered.where((ex) {
        final muscles = List<String>.from(ex['muscles_group'] ?? []);
        return muscles.any(
          (mg) => mg.toLowerCase() == _selectedMuscleGroup.toLowerCase(),
        );
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((ex) {
        final name = (ex['name'] as String? ?? '').toLowerCase();
        return name.contains(_searchQuery);
      }).toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'no_exercises_found'.tr(),
          style: const TextStyle(color: ColorConstants.textSecondaryColor),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final exercise = filtered[index];
        final rawId = exercise['exercise_id'];
        final exerciseId = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0;
        final name = (exercise['name'] as String?) ?? '';
        final musclesGroup = List<String>.from(exercise['muscles_group'] ?? []);
        final isSelected = _selectedIds.contains(exerciseId);
        final isAlreadyInPlan = widget.alreadySelectedIds.contains(exerciseId);

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedIds.remove(exerciseId);
                _selectedEntities.remove(exerciseId);
              } else {
                _selectedIds.add(exerciseId);
                _selectedEntities[exerciseId] = exercise;
              }
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorConstants.primaryColor.withValues(alpha: 0.08)
                  : ColorConstants.greyShade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? ColorConstants.primaryColor
                    : ColorConstants.greyShade200,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Exercise Icon / Image
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: ColorConstants.primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Exercise Name & Muscle Group
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        children: [
                          if (musclesGroup.isNotEmpty)
                            Text(
                              musclesGroup.join(', '),
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColorConstants.textSecondaryColor,
                              ),
                            ),
                          if (isAlreadyInPlan)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: ColorConstants.greyShade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'in_plan'.tr(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: ColorConstants.greyShade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Checkbox
                Checkbox(
                  value: isSelected,
                  activeColor: ColorConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedIds.add(exerciseId);
                        _selectedEntities[exerciseId] = exercise;
                      } else {
                        _selectedIds.remove(exerciseId);
                        _selectedEntities[exerciseId] = exercise;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
