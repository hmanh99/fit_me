import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/services/auth_services.dart';
import 'package:fit_me/features/profile/presentation/bloc/activity_history_bloc.dart';
import 'package:fit_me/features/profile/presentation/bloc/activity_history_event.dart';
import 'package:fit_me/features/profile/presentation/bloc/activity_history_state.dart';
import 'package:fit_me/features/profile/presentation/widgets/activity_history_card.dart';
import 'package:fit_me/features/profile/presentation/widgets/history_empty_state.dart';
import 'package:fit_me/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:fit_me/features/profile/presentation/widgets/profile_skeletons.dart';

import '../../../../core/constants/color_constants.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  late final String _userId;
  List items = [];
  @override
  void initState() {
    super.initState();
    _userId = AuthServices().user?.id ?? '';
    context.read<ActivityHistoryBloc>().add(
      FetchActivityHistory(userId: _userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: ProfileAppBar(
        title: "profile_activity_history_title".tr(),
        centerTitle: true,
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<ActivityHistoryBloc, ActivityHistoryState>(
        builder: (context, state) {
          if (state is ActivityHistoryLoading ||
              state is ActivityHistoryInitial) {
            return ProfileActivityHistoryScreenSkeletons();
          }

          if (state is ActivityHistoryError) {
            return HistoryEmptyState(
              onRefresh: () {
                context.read<ActivityHistoryBloc>().add(
                  FetchActivityHistory(userId: _userId),
                );
              },
            );
          }

          if (state is ActivityHistoryEmpty && items.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ActivityHistoryBloc>().add(
                  FetchActivityHistory(userId: _userId),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: HistoryEmptyState(
                    onRefresh: () {
                      context.read<ActivityHistoryBloc>().add(
                        FetchActivityHistory(userId: _userId),
                      );
                    },
                  ),
                ),
              ),
            );
          }

          if (state is ActivityHistoryLoaded) {
            final grouped = state.groupedHistories;
            final headers = grouped.keys.toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ActivityHistoryBloc>().add(
                  FetchActivityHistory(userId: _userId),
                );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: headers.length,
                itemBuilder: (context, index) {
                  final header = headers[index];
                  items = grouped[header] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Group Header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 4),
                        child: Text(
                          header,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textPrimaryColor,
                          ),
                        ),
                      ),
                      ...items.map(
                            (item) => ActivityHistoryCard(history: item),
                      ),
                    ],
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}