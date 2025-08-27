import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';  // Temporarily disabled
import 'package:firebase_storage/firebase_storage.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../l10n/app_localizations.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _selectedGender;
  File? _selectedImage;
  bool _isLoading = false;
  bool _isImageLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.userProfile;
    if (user != null) {
      _firstNameController.text = user.displayName?.split(' ').first ?? '';
      _lastNameController.text = user.displayName?.split(' ').skip(1).join(' ') ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      // You can add more fields as needed
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context)!.errorUpdatingPicture);
    }
  }

  // Future<void> _cropImage(File imageFile) async { // Temporarily disabled
  //   try {
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: imageFile.path,
  //       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //       uiSettings: [
  //         AndroidUiSettings(
  //           toolbarTitle: AppLocalizations.of(context)!.cropImage,
  //           toolbarColor: AppColors.primary,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.square,
  //           lockAspectRatio: true,
  //         ),
  //         IOSUiSettings(
  //           title: AppLocalizations.of(context)!.cropImage,
  //           aspectRatioLockEnabled: true,
  //           aspectRatioPickerButtonHidden: true,
  //         ),
  //       ],
  //     );

  //     if (croppedFile != null) {
  //       setState(() {
  //         _selectedImage = File(croppedFile.path);
  //       });
  //     }
  //   } catch (e) {
  //     _showErrorSnackBar(AppLocalizations.of(context)!.errorUpdatingPicture);
  //   }
  // }

  Future<void> _removeProfilePicture() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.areYouSure),
        content: Text(AppLocalizations.of(context)!.removeProfilePictureConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _selectedImage = null;
      });
      _showSuccessSnackBar(AppLocalizations.of(context)!.profilePictureRemoved);
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.userProfile;
      
      if (user == null) {
        _showErrorSnackBar(AppLocalizations.of(context)!.errorSavingChanges);
        return;
      }

      // Update profile picture if changed
      if (_selectedImage != null) {
        await _uploadProfilePicture();
      }

      // Update user profile data
      final displayName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
      final phoneNumber = _phoneController.text.trim();
      
      // Update in Firebase (you'll need to implement this in your AuthProvider)
      await authProvider.updateUserProfile(
        displayName: displayName,
        phoneNumber: phoneNumber,
        // Add other fields as needed
      );

      _showSuccessSnackBar(AppLocalizations.of(context)!.changesSaved);
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context)!.errorSavingChanges);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadProfilePicture() async {
    try {
      setState(() {
        _isImageLoading = true;
      });

      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');

      await storageRef.putFile(_selectedImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      // Update user profile with new photo URL
      await Provider.of<AuthProvider>(context, listen: false)
          .updateUserProfile(photoURL: downloadUrl);

      _showSuccessSnackBar(AppLocalizations.of(context)!.profilePictureUpdated);
    } catch (e) {
      _showErrorSnackBar(AppLocalizations.of(context)!.errorUpdatingPicture);
    } finally {
      setState(() {
        _isImageLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userProfile;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProfile),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (user.photoURL != null
                                  ? NetworkImage(user.photoURL!)
                                  : null) as ImageProvider?,
                          child: (_selectedImage == null && user.photoURL == null)
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        if (_isImageLoading)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              onPressed: () => _showImageSourceDialog(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    TextButton(
                      onPressed: _selectedImage != null || user.photoURL != null
                          ? _removeProfilePicture
                          : null,
                      child: Text(
                        AppLocalizations.of(context)!.removePhoto,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // Personal Information Section
              Text(
                AppLocalizations.of(context)!.personalInfo,
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSizes.md),

              // First Name
              CustomTextField(
                controller: _firstNameController,
                labelText: AppLocalizations.of(context)!.firstName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.md),

              // Last Name
              CustomTextField(
                controller: _lastNameController,
                labelText: AppLocalizations.of(context)!.lastName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.md),

              // Phone Number
              CustomTextField(
                controller: _phoneController,
                labelText: AppLocalizations.of(context)!.phoneNumber,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSizes.md),

              // Gender Selection
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.gender,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'male',
                    child: Text(AppLocalizations.of(context)!.male),
                  ),
                  DropdownMenuItem(
                    value: 'female',
                    child: Text(AppLocalizations.of(context)!.female),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),

              const SizedBox(height: AppSizes.xl),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  text: _isLoading
                      ? AppLocalizations.of(context)!.loading
                      : AppLocalizations.of(context)!.saveChanges,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.selectProfilePicture,
              style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSizes.lg),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
