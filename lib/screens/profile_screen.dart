import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../models/profile.dart';
import '../l10n/l10n.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../utils/locale_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService profileService = GetIt.I<ProfileService>();
  final AuthService authService = GetIt.I<AuthService>();
  final LocaleController localeController = GetIt.I<LocaleController>();

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  UserProfile? profile;
  bool loading = true;
  bool saving = false;
  String? errorText;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        loading = false;
        errorText = context.l10n.notAuthenticated;
      });
      return;
    }

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      final loaded = await profileService.getProfile();
      if (!mounted) return;

      setState(() {
        profile = loaded;
        _language = loaded.language.isNotEmpty ? loaded.language : 'en';
        loading = false;
      });

      localeController.setLanguage(_language);

      displayNameController.text = loaded.displayName.isNotEmpty ? loaded.displayName : (user.displayName ?? '');
      cityController.text = loaded.city;
      aboutController.text = loaded.about;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorText = context.l10n.failedToLoadProfile(e.toString());
      });
    }
  }

  Future<void> _save() async {
    if (saving) return;

    setState(() {
      saving = true;
      errorText = null;
    });

    try {
      final updated = await profileService.updateProfile(
        displayName: displayNameController.text,
        city: cityController.text,
        about: aboutController.text,
        language: _language,
      );
      if (!mounted) return;

      setState(() {
        profile = updated;
        _language = updated.language.isNotEmpty ? updated.language : _language;
        saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileSaved)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        saving = false;
        errorText = context.l10n.failedToSaveProfile(e.toString());
      });
    }
  }

  Future<void> _logout() async {
    await authService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _changeLanguage(String value) async {
    setState(() => _language = value);
    localeController.setLanguage(value);

    try {
      await profileService.updateProfile(language: value);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToSaveProfile(e.toString()))),
      );
    }
  }

  @override
  void dispose() {
    displayNameController.dispose();
    cityController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profile),
        actions: [
          IconButton(
            onPressed: saving ? null : _save,
            icon: saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (errorText != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.25)),
                      ),
                      child: Text(
                        errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.account,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text('${context.l10n.email}: ${firebaseUser?.email ?? '-'}'),
                          Text('${context.l10n.uid}: ${firebaseUser?.uid ?? '-'}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.profileSection,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: displayNameController,
                            decoration: InputDecoration(
                              labelText: context.l10n.displayName,
                              border: const OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: cityController,
                            decoration: InputDecoration(
                              labelText: context.l10n.city,
                              border: const OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: aboutController,
                            decoration: InputDecoration(
                              labelText: context.l10n.about,
                              border: const OutlineInputBorder(),
                            ),
                            maxLines: 4,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _language,
                            decoration: InputDecoration(
                              labelText: context.l10n.language,
                              border: const OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(value: 'en', child: Text(context.l10n.english)),
                              DropdownMenuItem(value: 'ru', child: Text(context.l10n.russian)),
                              DropdownMenuItem(value: 'kk', child: Text(context.l10n.kazakh)),
                            ],
                            onChanged: saving
                                ? null
                                : (value) {
                                    if (value == null) return;
                                    _changeLanguage(value);
                                  },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: saving ? null : _save,
                                  child: Text(context.l10n.save),
                                ),
                              ),
                            ],
                          ),
                          if (profile?.updatedAt != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Updated: ${profile!.updatedAt}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: Text(context.l10n.logout),
                  ),
                ],
              ),
            ),
    );
  }
}
