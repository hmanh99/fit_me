import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/shared/widgets/skeletons.dart';

class ProfileScreenSkeleton extends StatelessWidget {
  const ProfileScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    AppSkeleton.circle(size: 100),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        AppSkeleton.line(width: 150),
                        const SizedBox(height: 16),
                        AppSkeleton.line(width: 150),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeleton.line(width: 150),
                    const SizedBox(height: 16),
                    SkeletonListTile(),
                    _divider(),
                    SkeletonListTile(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeleton.line(width: 150),
                    const SizedBox(height: 16),
                    SkeletonListTile(),
                    _divider(),
                    SkeletonListTile(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeleton.line(width: 150),
                    const SizedBox(height: 16),
                    SkeletonListTile(),
                    _divider(),
                    SkeletonListTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetailScreenSkeleton extends StatelessWidget {
  const ProfileDetailScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    AppSkeleton.circle(size: 100),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        AppSkeleton.line(width: 150),
                        const SizedBox(height: 16),
                        AppSkeleton.line(width: 150),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppSkeleton.line(width: 80),
                                const SizedBox(width: 32),
                                AppSkeleton.circle(size: 20),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AppSkeleton.line(width: 130),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppSkeleton.line(width: 80),
                                const SizedBox(width: 16),
                                AppSkeleton.circle(size: 20),
                              ],
                            ),
                            const SizedBox(height: 24),
                            AppSkeleton.line(width: 130),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppSkeleton.line(width: 200),
                        AppSkeleton.line(width: 50),
                      ],
                    ),
                    AppSkeleton.line(),
                    AppSkeleton.line(),
                    _divider(),
                    AppSkeleton.line(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileScreenSkeleton extends StatelessWidget {
  const EditProfileScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSkeleton.circle(size: 100),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppSkeleton.circle(size: 100),
                        AppSkeleton.circle(size: 100),
                        AppSkeleton.circle(size: 100),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppSkeleton.circle(size: 100),
                        AppSkeleton.circle(size: 100),
                        AppSkeleton.circle(size: 100),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppSkeleton.line(
                      height: 24,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSkeleton.line(
                      height: 16,
                      width: 150,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    const SizedBox(height: 16),
                    AppSkeleton.line(
                      height: 20,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    const SizedBox(height: 16),
                    AppSkeleton.line(
                      height: 20,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    const SizedBox(height: 16),
                    AppSkeleton.line(
                      height: 20,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _divider() {
  return Divider(height: 1, thickness: 1, color: Colors.grey.shade100);
}
