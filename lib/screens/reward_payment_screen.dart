import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../services/item_service.dart';

class RewardPaymentScreen extends StatefulWidget {
  const RewardPaymentScreen({super.key});

  @override
  State<RewardPaymentScreen> createState() => _RewardPaymentScreenState();
}

class _RewardPaymentScreenState extends State<RewardPaymentScreen> {
  static const int _minCents = 100;
  static const int _maxCents = 10000;

  final ItemService itemService = GetIt.I<ItemService>();

  final TextEditingController amountController = TextEditingController();
  bool loading = false;
  int? selectedCents;

  final List<int> presets = const [100, 300, 500, 1000, 2000, 5000]; // $1..$50

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  int? _parseCustomAmountCents() {
    final text = amountController.text.trim();
    if (text.isEmpty) return null;
    final dollars = int.tryParse(text);
    if (dollars == null) return null;
    return dollars * 100;
  }

  int? _resolveAmountCents() => selectedCents ?? _parseCustomAmountCents();

  Future<void> _pay() async {
    final amountCents = _resolveAmountCents();
    if (amountCents == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.invalidAmount)),
      );
      return;
    }
    if (amountCents < _minCents || amountCents > _maxCents) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.amountRange(_maxCents ~/ 100, _minCents ~/ 100))),
      );
      return;
    }

    setState(() => loading = true);
    try {
      final url = await itemService.createRewardPayment(amountCents: amountCents);
      final uri = Uri.tryParse(url);
      if (uri == null) {
        throw Exception('Invalid checkout URL');
      }
      final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (!ok) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.paymentFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedCents;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.rewardPayment)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.l10n.chooseAmount,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presets.map((cents) {
              final isSelected = selected == cents;
              return ChoiceChip(
                label: Text(context.l10n.amountUsd(cents ~/ 100)),
                selected: isSelected,
                onSelected: loading
                    ? null
                    : (v) {
                        setState(() {
                          selectedCents = v ? cents : null;
                          if (v) amountController.clear();
                        });
                      },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            enabled: !loading,
            decoration: InputDecoration(
              labelText: context.l10n.customAmountUsd,
              helperText: context.l10n.amountRange(_maxCents ~/ 100, _minCents ~/ 100),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              if (selectedCents != null) {
                setState(() => selectedCents = null);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: loading ? null : _pay,
            icon: const Icon(Icons.payment),
            label: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.pay),
          ),
        ],
      ),
    );
  }
}
