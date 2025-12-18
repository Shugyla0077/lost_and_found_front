import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../models/profile.dart';
import '../l10n/l10n.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../utils/locale_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.embedded = false, this.active = true});

  final bool embedded;
  final bool active;

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
  bool editing = false;
  String? errorText;
  String _language = 'en';
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    if (widget.active) {
      _hasLoadedOnce = true;
      _load();
    } else {
      loading = false;
    }
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active && widget.active && !_hasLoadedOnce) {
      _hasLoadedOnce = true;
      setState(() => loading = true);
      _load();
    }
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
        editing = false;
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

  void _startEditing() {
    setState(() {
      editing = true;
      errorText = null;
    });
  }

  void _cancelEditing() {
    final user = FirebaseAuth.instance.currentUser;
    final p = profile;
    if (p != null) {
      displayNameController.text = p.displayName.isNotEmpty ? p.displayName : (user?.displayName ?? '');
      cityController.text = p.city;
      aboutController.text = p.about;
      _language = p.language.isNotEmpty ? p.language : 'en';
      localeController.setLanguage(_language);
    }

    setState(() {
      editing = false;
      saving = false;
      errorText = null;
    });
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
        editing = false;
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

  void _changeLanguage(String value) {
    setState(() => _language = value);
    localeController.setLanguage(value);
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
    final scheme = Theme.of(context).colorScheme;

    final body = loading
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
                        color: scheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.errorContainer),
                      ),
                      child: Text(
                        errorText!,
                        style: TextStyle(color: scheme.onErrorContainer),
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
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: scheme.tertiaryContainer,
                        foregroundColor: scheme.onTertiaryContainer,
                        child: const Icon(Icons.check),
                      ),
                      title: Text(
                        context.l10n.claimedItems,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(context.l10n.viewClaimedItems),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/claimedItems');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: scheme.primaryContainer,
                        foregroundColor: scheme.onPrimaryContainer,
                        child: const Icon(Icons.payment),
                      ),
                      title: Text(
                        context.l10n.rewardPayment,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(context.l10n.rewardPaymentSubtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/rewardPayment');
                      },
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
                            enabled: editing && !saving,
                            decoration: InputDecoration(
                              labelText: context.l10n.displayName,
                              prefixIcon: const Icon(Icons.badge_outlined),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: cityController,
                            enabled: editing && !saving,
                            decoration: InputDecoration(
                              labelText: context.l10n.city,
                              prefixIcon: const Icon(Icons.location_city_outlined),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: aboutController,
                            enabled: editing && !saving,
                            decoration: InputDecoration(
                              labelText: context.l10n.about,
                              prefixIcon: const Icon(Icons.info_outline),
                            ),
                            maxLines: 4,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _language,
                            disabledHint: Text(_language),
                            decoration: InputDecoration(
                              labelText: context.l10n.language,
                              prefixIcon: const Icon(Icons.language_outlined),
                            ),
                            items: [
                              DropdownMenuItem(value: 'en', child: Text(context.l10n.english)),
                              DropdownMenuItem(value: 'ru', child: Text(context.l10n.russian)),
                              DropdownMenuItem(value: 'kk', child: Text(context.l10n.kazakh)),
                            ],
                            onChanged: (!editing || saving)
                                ? null
                                : (value) {
                                    if (value == null) return;
                                    _changeLanguage(value);
                                  },
                          ),
                          const SizedBox(height: 12),
                          if (!editing) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _startEditing,
                                    icon: const Icon(Icons.edit),
                                    label: Text(context.l10n.edit),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: saving ? null : _save,
                                    child: saving
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : Text(context.l10n.save),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: saving ? null : _cancelEditing,
                                    child: Text(context.l10n.cancel),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
            );

    if (widget.embedded) return body;
    return Scaffold(appBar: AppBar(title: Text(context.l10n.profile)), body: body);
  }
}
