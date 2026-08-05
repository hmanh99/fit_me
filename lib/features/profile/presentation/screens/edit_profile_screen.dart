import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_event.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_state.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/profile_skeletons.dart';

class EditProfileScreen extends StatefulWidget {
  final String profileId;

  const EditProfileScreen({super.key, required this.profileId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _customAvatarController;

  String? _selectedAvatarUrl;
  bool _isSaving = false;
  bool _isInitialized = false;
  final List<String> _presetAvatars = const [
    'https://images.unsplash.com/photo-1728577740843-5f29c7586afe?auto=format&fit=crop&w=200&q=80',
    'https://images.unsplash.com/photo-1740252117070-7aa2955b25f8?q=80&w=200&auto=format&fit=crop',
    'https://plus.unsplash.com/premium_vector-1728560971527-140ca22e3d81?q=80&w=200&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1740252117027-4275d3f84385?q=80&w=200&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1740252117013-4fb21771e7ca?q=80&w=200&auto=format&fit=crop',
    'https://plus.unsplash.com/premium_photo-1738550163729-ac47e1d5f8f5?q=80&w=200&auto=format&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _customAvatarController = TextEditingController();

    final existingProfile = context.read<ProfileBloc>().state.profile;
    if (existingProfile != null && existingProfile.userId == widget.profileId) {
      _prefillFields(existingProfile);
    }
    context.read<ProfileBloc>().add(ProfileFetched(userId: widget.profileId));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _customAvatarController.dispose();
    super.dispose();
  }

  void _prefillFields(ProfileEntity profile) {
    _usernameController.text = profile.username;
    _heightController.text = profile.height.toStringAsFixed(0);
    _weightController.text = profile.weight.toStringAsFixed(0);
    _selectedAvatarUrl = profile.avatar;
    if (_selectedAvatarUrl != null) {
      _customAvatarController.text = _selectedAvatarUrl!;
    }
    _isInitialized = true;
  }

  void _onSave(ProfileState state) {
    if (state is! ProfileLoaded) return;
    if (!_formKey.currentState!.validate()) return;
    final profile = state.profile;
    final newUsername = _usernameController.text.trim();
    final newHeight = double.tryParse(_heightController.text) ?? profile.height;
    final newWeight = double.tryParse(_weightController.text) ?? profile.weight;
    final newAvatar = _selectedAvatarUrl?.trim();
    final hasUsernameChanged = newUsername != profile.username;
    final hasHeightChanged = (newHeight - profile.height).abs() > 0.01;
    final hasWeightChanged = (newWeight - profile.weight).abs() > 0.01;
    final hasAvatarChanged = newAvatar != profile.avatar;
    if (!hasUsernameChanged &&
        !hasHeightChanged &&
        !hasWeightChanged &&
        !hasAvatarChanged) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No changes made')));
      context.pop();
      return;
    }
    setState(() {
      _isSaving = true;
    });
    context.read<ProfileBloc>().add(
      ProfileUpdateRequested(
        username: hasUsernameChanged ? newUsername : null,
        height: hasHeightChanged ? newHeight : null,
        weight: hasWeightChanged ? newWeight : null,
        avatar: hasAvatarChanged ? (newAvatar ?? '') : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded && !_isInitialized) {
          _usernameController.text = state.profile.username;
          _heightController.text = state.profile.height.toStringAsFixed(0);
          _weightController.text = state.profile.weight.toStringAsFixed(0);
          _selectedAvatarUrl = state.profile.avatar;
          if (_selectedAvatarUrl != null) {
            _customAvatarController.text = _selectedAvatarUrl!;
          }
          _isInitialized = true;
        }
        if (_isSaving && state is ProfileLoaded) {
          final current = state.profile;
          final targetUsername = _usernameController.text.trim();
          final targetHeight =
              double.tryParse(_heightController.text) ?? current.height;
          final targetWeight =
              double.tryParse(_weightController.text) ?? current.weight;
          final targetAvatar = _selectedAvatarUrl?.trim();
          if (current.username == targetUsername &&
              (current.height - targetHeight).abs() < 0.01 &&
              (current.weight - targetWeight).abs() < 0.01 &&
              (current.avatar == targetAvatar ||
                  (current.avatar == null && targetAvatar == null))) {
            setState(() {
              _isSaving = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        }
        if (state is ProfileError) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading && !_isInitialized;
        return Scaffold(
          appBar: ProfileAppBar(
            title: "Edit Profile",
            centerTitle: true,
            onBack: () => context.pop(),
          ),
          body: isLoading
              ? const EditProfileScreenSkeleton()
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAvatarSelector(),
                        const SizedBox(height: 20),
                        _buildFormFields(state),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAvatarSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Choose Avatar',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // Current selection preview
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundImage: _selectedAvatarUrl != null
                  ? NetworkImage(_selectedAvatarUrl!)
                  : null,
              backgroundColor: Colors.grey.shade200,
              child: _selectedAvatarUrl == null
                  ? const Icon(Icons.person, size: 44, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          // Preset grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _presetAvatars.length,
            itemBuilder: (context, index) {
              final url = _presetAvatars[index];
              final isSelected = _selectedAvatarUrl == url;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatarUrl = url;
                    _customAvatarController.text = url;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Color(0xFF92A3FD)
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(url),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Custom URL input
          TextFormField(
            controller: _customAvatarController,
            decoration: InputDecoration(
              labelText: 'Or paste image URL',
              labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              prefixIcon: const Icon(Icons.link_rounded, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF92A3FD),
                  width: 1.5,
                ),
              ),
            ),
            style: const TextStyle(fontSize: 13),
            onChanged: (val) {
              setState(() {
                _selectedAvatarUrl = val.trim().isEmpty ? null : val.trim();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(ProfileState state) {
    final isSavingOrUpdating = _isSaving || state is ProfileUpdating;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              enabled: !isSavingOrUpdating,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Username is required';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(
                  Icons.person_outline_rounded,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF92A3FD),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              enabled: !isSavingOrUpdating,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Height is required';
                final height = double.tryParse(val);
                if (height == null || height <= 0) {
                  return 'Enter a valid height';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                prefixIcon: const Icon(
                  Icons.height_rounded,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF92A3FD),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              enabled: !isSavingOrUpdating,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Weight is required';
                final weight = double.tryParse(val);
                if (weight == null || weight <= 0) {
                  return 'Enter a valid weight';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                prefixIcon: const Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF92A3FD),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF92A3FD),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: isSavingOrUpdating ? null : () => _onSave(state),
              child: isSavingOrUpdating
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
