import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_event.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_state.dart';
import 'package:fit_me/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:fit_me/features/profile/presentation/widgets/profile_skeletons.dart';

import '../../../../core/constants/color_constants.dart';

class EditProfileScreen extends StatefulWidget {
  final String profileId;

  const EditProfileScreen({super.key, required this.profileId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  late final TextEditingController _usernameController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _customAvatarController;

  String? _selectedAvatarUrl;
  bool _isSaving = false;
  bool _isInitialized = false;

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        context.read<ProfileBloc>().add(
              ProfileAvatarUploadRequested(
                userId: widget.profileId,
                filePath: pickedFile.path,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: ColorConstants.errorColor,
          ),
        );
      }
    }
  }

  void _deleteAvatar() {
    context.read<ProfileBloc>().add(
          ProfileAvatarDeleteRequested(
            userId: widget.profileId,
            currentAvatarUrl: _selectedAvatarUrl,
          ),
        );
  }

  void _showAvatarSourceSheet() {
    final hasAvatar =
        _selectedAvatarUrl != null && _selectedAvatarUrl!.trim().isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: ColorConstants.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'change_avatar'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorConstants.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                  title: Text(
                    'take_photo'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.textPrimaryColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorConstants.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                  title: Text(
                    'choose_from_gallery'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.textPrimaryColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (hasAvatar)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorConstants.errorColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: ColorConstants.errorColor,
                      ),
                    ),
                    title: Text(
                      'remove_photo'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.errorColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _deleteAvatar();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSave(ProfileState state) {
    if (state is! ProfileLoaded && state is! ProfileUpdating) return;
    if (!_formKey.currentState!.validate()) return;
    final profile = state.profile;
    if (profile == null) return;

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
      ).showSnackBar(SnackBar(content: Text('no_changes_message'.tr())));
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
        if (state is ProfileLoaded) {
          if (!_isInitialized) {
            _usernameController.text = state.profile.username;
            _heightController.text = state.profile.height.toStringAsFixed(0);
            _weightController.text = state.profile.weight.toStringAsFixed(0);
            _isInitialized = true;
          }
          _selectedAvatarUrl = state.profile.avatar;
          _customAvatarController.text = state.profile.avatar ?? '';

          if (_isSaving) {
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
                SnackBar(
                  content: Text('update_success_message'.tr()),
                  backgroundColor: ColorConstants.snackBarSuccessColor,
                ),
              );
              context.pop();
            }
          }
        }
        if (state is ProfileError) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorConstants.errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading && !_isInitialized;
        final isAvatarUploading = state is ProfileAvatarUploading;

        return Scaffold(
          backgroundColor: ColorConstants.backgroundColor,
          appBar: ProfileAppBar(
            title: "profile_edit_profile_button".tr(),
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
                        _buildAvatarSelector(isAvatarUploading),
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

  Widget _buildAvatarSelector(bool isAvatarUploading) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorConstants.borderLightColor),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'choose_avatar_title'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimaryColor,
                ),
              ),
              if (_selectedAvatarUrl != null &&
                  _selectedAvatarUrl!.trim().isNotEmpty)
                TextButton.icon(
                  onPressed: isAvatarUploading ? null : _deleteAvatar,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: ColorConstants.errorColor,
                  ),
                  label: Text(
                    'remove_photo'.tr(),
                    style: const TextStyle(
                      color: ColorConstants.errorColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Camera
          Center(
            child: GestureDetector(
              onTap: isAvatarUploading ? null : _showAvatarSourceSheet,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorConstants.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    child: ClipOval(
                      child: _selectedAvatarUrl != null &&
                              _selectedAvatarUrl!.trim().isNotEmpty
                          ? Image.network(
                              _selectedAvatarUrl!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: ColorConstants.greyShade200,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: ColorConstants.greyShade400,
                                ),
                              ),
                            )
                          : Container(
                              color: ColorConstants.greyShade200,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: ColorConstants.greyShade400,
                              ),
                            ),
                    ),
                  ),
                  if (isAvatarUploading)
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: ColorConstants.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.white,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  else
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorConstants.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorConstants.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  ColorConstants.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 20,
                          color: ColorConstants.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: isAvatarUploading ? null : _showAvatarSourceSheet,
              icon: const Icon(
                Icons.photo_camera_rounded,
                size: 18,
                color: ColorConstants.primaryColor,
              ),
              label: Text(
                'change_avatar'.tr(),
                style: const TextStyle(
                  color: ColorConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFormFields(ProfileState state) {
    final isSavingOrUpdating =
        _isSaving || state is ProfileUpdating || state is ProfileAvatarUploading;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorConstants.greyShade100),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.03),
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
            Text(
              'personal_info_title'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              enabled: !isSavingOrUpdating,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'username_required_error'.tr();
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'username'.tr(),
                prefixIcon: const Icon(
                  Icons.person_outline_rounded,
                  color: ColorConstants.grey,
                ),
                filled: true,
                fillColor: ColorConstants.greyShade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: ColorConstants.primaryColor,
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
                if (val == null || val.isEmpty) {
                  return 'height_required_error'.tr();
                }
                final height = double.tryParse(val);
                if (height == null || height <= 0) {
                  return 'height_invalid_error'.tr();
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'height'.tr(),
                prefixIcon: const Icon(
                  Icons.height_rounded,
                  color: ColorConstants.grey,
                ),
                filled: true,
                fillColor: ColorConstants.greyShade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: ColorConstants.primaryColor,
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
                if (val == null || val.isEmpty) {
                  return 'weight_required_error'.tr();
                }
                final weight = double.tryParse(val);
                if (weight == null || weight <= 0) {
                  return 'weight_invalid_error'.tr();
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'weight'.tr(),
                prefixIcon: const Icon(
                  Icons.fitness_center_rounded,
                  color: ColorConstants.grey,
                ),
                filled: true,
                fillColor: ColorConstants.greyShade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: ColorConstants.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                foregroundColor: ColorConstants.buttonTextColor,
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
                        color: ColorConstants.buttonTextColor,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      "save_changes_button".tr(),
                      style: const TextStyle(
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
