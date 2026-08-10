import 'dart:async';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/router/route_names.dart';
import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';
import 'package:fit_me/features/meal/domain/entities/meal_type.dart';
import 'package:fit_me/features/meal/presentation/bloc/meal_bloc.dart';
import 'package:fit_me/features/meal/presentation/bloc/meal_event.dart';
import 'package:fit_me/features/meal/presentation/bloc/meal_state.dart';
import 'package:fit_me/features/meal/presentation/widgets/meal_app_bar.dart';
import 'package:fit_me/features/meal/presentation/widgets/meal_card.dart';
import 'package:fit_me/features/meal/presentation/widgets/meal_empty_view.dart';
import 'package:fit_me/features/meal/presentation/widgets/meal_error_view.dart';
import 'package:fit_me/features/meal/presentation/widgets/meal_header.dart';
import 'package:fit_me/features/meal/presentation/widgets/meal_loading_skeleton.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  MealType? _selectedType;
  List<MealEntity> _allMeals = [];
  bool _hasLoadedOnce = false;

  static const int _pageSize = 5;
  static const int _firstPageKey = 1;

  late final PagingController<int, MealEntity> _pagingController =
  PagingController<int, MealEntity>(
    getNextPageKey: (state) {
      final filtered = _getFilteredMeals();
      if (filtered.isEmpty) return null;

      if (state.lastPageIsEmpty) return null;

      final loadedCount = state.items?.length ?? 0;
      if (loadedCount >= filtered.length) return null;

      return state.nextIntPageKey;
    },
    fetchPage: (pageKey) async {
      if (_firstPageKey == 1) {
        await Future.delayed(const Duration(milliseconds: 300));

        final filtered = _getFilteredMeals();
        final start = (pageKey - _firstPageKey) * _pageSize;
        if (start >= filtered.length) return <MealEntity>[];

        final end = math.min(start + _pageSize, filtered.length);
        return filtered.sublist(start, end);
      }else{
        await Future.delayed(const Duration(seconds: 2));

        final filtered = _getFilteredMeals();
        final start = (pageKey - _firstPageKey) * _pageSize;
        if (start >= filtered.length) return <MealEntity>[];

        final end = math.min(start + _pageSize, filtered.length);
        return filtered.sublist(start, end);
      }
    },
  );

  @override
  void initState() {
    super.initState();
    context.read<MealBloc>().add(const MealFetchStarted());
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  List<MealEntity> _getFilteredMeals() {
    if (_selectedType == null) {
      return _allMeals;
    }
    return _allMeals.where((meal) => meal.mealType == _selectedType).toList();
  }

  void _onTypeSelected(MealType? type) {
    setState(() {
      _selectedType = type;
    });
    _resetPaging();
  }

  void _resetPaging() {
    _pagingController.refresh();
  }

  Future<void> _handleRefresh() async {
    final bloc = context.read<MealBloc>();
    bloc.add(const MealFetchStarted());

    await bloc.stream.firstWhere(
          (state) =>
      state is MealSuccess || state is MealEmpty || state is MealError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: MealAppBar(title: "meal".tr(),),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: ColorConstants.iconColor,
        backgroundColor: ColorConstants.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            MealHeader(
              selectedType: _selectedType,
              onTypeSelected: _onTypeSelected,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocConsumer<MealBloc, MealState>(
                listener: (context, state) {
                  if (state is MealSuccess) {
                    setState(() {
                      _allMeals = state.meals;
                      _hasLoadedOnce = true;
                    });
                    _resetPaging();
                  } else if (state is MealEmpty) {
                    setState(() {
                      _allMeals = [];
                      _hasLoadedOnce = true;
                    });
                  }
                },
                builder: (context, state) {
                  final filteredMeals = _getFilteredMeals();

                  if (state is MealLoading && _allMeals.isEmpty) {
                    return const MealLoadingSkeleton();
                  }
                  if (state is MealError && _allMeals.isEmpty) {
                    return MealErrorView(
                      errorMessage: state.message,
                      onRetry: () {
                        context.read<MealBloc>().add(const MealFetchStarted());
                      },
                    );
                  }
                  if (state is MealEmpty || (_hasLoadedOnce && _allMeals.isEmpty)) {
                    return MealEmptyView(onRefresh: _handleRefresh);
                  }
                  if (!_hasLoadedOnce) {
                    return const MealLoadingSkeleton();
                  }
                  if (filteredMeals.isEmpty) {
                    return MealEmptyView(onRefresh: _handleRefresh);
                  }

                  return PagingListener<int, MealEntity>(
                    controller: _pagingController,
                    builder: (context, pagingState, fetchNextPage) =>
                        PagedListView<int, MealEntity>(
                          state: pagingState,
                          fetchNextPage: fetchNextPage,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            16,
                            8,
                            16,
                            MediaQuery.of(context).padding.bottom,
                          ),
                          builderDelegate:
                          PagedChildBuilderDelegate<MealEntity>(
                            itemBuilder: (context, meal, index) {
                              return TweenAnimationBuilder<double>(
                                key: ValueKey(meal.mealId),
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: Duration(
                                  milliseconds: 200 + (index * 50),
                                ),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: MealCard(
                                  meal: meal,
                                  onTap: () {
                                    context.goNamed(
                                      AppRouteNames.appMealDetail,
                                      pathParameters: {
                                        'mealId': meal.mealId.toString(),
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            firstPageProgressIndicatorBuilder: (context) =>
                            _hasLoadedOnce
                                ? const SizedBox.shrink()
                                : const MealLoadingSkeleton(),
                            newPageProgressIndicatorBuilder: (context) =>
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Color(0xFF92A3FD),
                                  ),
                                ),
                              ),
                            ),
                            firstPageErrorIndicatorBuilder: (context) =>
                                MealErrorView(
                                  errorMessage: 'server_exception'.tr(),
                                  onRetry: _pagingController.fetchNextPage,
                                ),
                            newPageErrorIndicatorBuilder: (context) =>
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Center(
                                    child: TextButton.icon(
                                      onPressed:
                                      _pagingController.fetchNextPage,
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                      ),
                                      label:  Text('retry'.tr()),
                                    ),
                                  ),
                                ),
                            noItemsFoundIndicatorBuilder: (context) =>
                                MealEmptyView(onRefresh: _handleRefresh),
                          ),
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}