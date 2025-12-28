import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() => _isLoading = true);

    try {
      final File file = File(image.path);
      final String fileName =
          'profile_${FirebaseAuth.instance.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await Supabase.instance.client.storage
          .from('profile_image')
          .upload(fileName, file);

      final String imageUrl = Supabase.instance.client.storage
          .from('profile_image')
          .getPublicUrl(fileName);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePhotoURL(imageUrl);
        await user.reload();
        setState(() {});
        _showSnackBar('Foto profil berhasil diperbarui');
      }
    } catch (e) {
      _showSnackBar('Gagal mengupload foto: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());

        final newEmail = _emailController.text.trim();
        if (newEmail != user.email && newEmail.isNotEmpty) {
          await user.verifyBeforeUpdateEmail(newEmail);
          _showSnackBar('Email verifikasi dikirim ke $newEmail');
        }

        if (_newPasswordController.text.isNotEmpty) {
          if (_newPasswordController.text != _confirmPasswordController.text) {
            _showSnackBar('Password baru tidak cocok');
            setState(() => _isLoading = false);
            return;
          }
          if (_newPasswordController.text.length < 6) {
            _showSnackBar('Password minimal 6 karakter');
            setState(() => _isLoading = false);
            return;
          }

          await user.updatePassword(_newPasswordController.text);
        }
      }

      if (mounted) {
        _showSnackBar('Profil berhasil diperbarui');
        Navigator.pop(context);
      }
    } catch (e) {
      _showSnackBar('Gagal memperbarui profil');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.softShadow,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppTheme.textPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profil', style: AppTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          FirebaseAuth.instance.currentUser?.photoURL != null
                          ? NetworkImage(
                              FirebaseAuth.instance.currentUser!.photoURL!,
                            )
                          : null,
                      child: FirebaseAuth.instance.currentUser?.photoURL == null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[400],
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: AppTheme.softShadow,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
            ], // Close Column children (will be filled more later)
          ),
        ),
      ),
    );
  }
}
