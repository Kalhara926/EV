// lib/screens/edit_profile_screen.dart

import 'dart:io';
import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  File? _pickedImageFile;
  String? _existingImageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.userData['first_name'] ?? '';
    _lastNameController.text = widget.userData['last_name'] ?? '';
    _emailController.text = widget.userData['email'] ?? '';
    _mobileController.text = widget.userData['mobile_number'] ?? '';
    _existingImageUrl = widget.userData['profile_image_url'];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (pickedImage != null) {
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);
    final user = FirebaseAuth.instance.currentUser!;
    String? newImageUrl;

    try {
      if (_pickedImageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pics')
            .child('${user.uid}.jpg');
        await ref.putFile(_pickedImageFile!);
        newImageUrl = await ref.getDownloadURL();
      }

      final Map<String, dynamic> dataToUpdate = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile_number': _mobileController.text.trim(),
      };

      if (newImageUrl != null) {
        dataToUpdate['profile_image_url'] = newImageUrl;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(dataToUpdate);

      if (user.email != _emailController.text.trim()) {
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
      }

      if (mounted) {
        _showSnackBar(l10n.profileUpdatedSuccess, isError: false);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(l10n.profileUpdateFailed(e.toString()), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Theme.of(context).colorScheme.error : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _pickedImageFile != null
                    ? FileImage(_pickedImageFile!)
                    : (_existingImageUrl != null &&
                            _existingImageUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(_existingImageUrl!)
                        : null) as ImageProvider?,
                child: _pickedImageFile == null &&
                        (_existingImageUrl == null ||
                            _existingImageUrl!.isEmpty)
                    ? Icon(Icons.camera_alt,
                        size: 50, color: Colors.grey.shade600)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(l10n.tapToChange, style: theme.textTheme.bodySmall),
            const SizedBox(height: 30),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                  labelText: l10n.firstNameHint,
                  prefixIcon: const Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                  labelText: l10n.lastNameHint,
                  prefixIcon: const Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: l10n.emailHint,
                  prefixIcon: const Icon(Icons.email_outlined)),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                  labelText: l10n.mobileNumberHint,
                  prefixIcon: const Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 40),
            _isSaving
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text(l10n.saveChanges),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
