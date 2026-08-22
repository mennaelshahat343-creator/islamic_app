import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/tasbeeh_provider.dart';

class TasbeehScreen extends ConsumerStatefulWidget {
  const TasbeehScreen({super.key});

  @override
  ConsumerState<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends ConsumerState<TasbeehScreen> {
  bool _vibrationEnabled = true;

  Future<void> _handleTap() async {
    ref.read(tasbeehProvider.notifier).increment();
    if (_vibrationEnabled) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 30);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasbeehProvider);
    final total = ref.read(tasbeehProvider.notifier).totalAllTime;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tasbeehTitle),
        actions: [
          IconButton(
            icon: Icon(_vibrationEnabled ? Icons.vibration_rounded : Icons.mobile_off_rounded),
            onPressed: () => setState(() => _vibrationEnabled = !_vibrationEnabled),
            tooltip: 'الاهتزاز',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // ---------- اختيار الذكر ----------
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: TasbeehNotifier.presetAdhkar.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final dhikr = TasbeehNotifier.presetAdhkar[index];
                  final selected = state.dhikrId == dhikr['id'];
                  return ChoiceChip(
                    label: Text(dhikr['text']!),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: selected ? Colors.white : null),
                    onSelected: (_) => ref.read(tasbeehProvider.notifier).selectDhikr(dhikr['id']!, dhikr['text']!),
                  );
                },
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _handleTap,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 30, spreadRadius: 4),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${state.count}',
                          style: const TextStyle(fontSize: 64, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(state.dhikrText, style: const TextStyle(fontSize: 18, color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('${AppStrings.totalCount} (الكل)', style: Theme.of(context).textTheme.bodyMedium),
                      Text('$total', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () => ref.read(tasbeehProvider.notifier).reset(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text(AppStrings.resetCounter),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
