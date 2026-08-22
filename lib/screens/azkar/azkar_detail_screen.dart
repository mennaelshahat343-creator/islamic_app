import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../models/azkar_model.dart';

/// شاشة عرض أذكار فئة معيّنة مع عدّاد لكل ذكر (Page per dhikr)
class AzkarDetailScreen extends StatefulWidget {
  final AzkarCategory category;
  const AzkarDetailScreen({super.key, required this.category});

  @override
  State<AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<AzkarDetailScreen> {
  late final PageController _controller;
  int _currentIndex = 0;
  late List<int> _remaining;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _remaining = widget.category.items.map((e) => e.repeat).toList();
  }

  void _count() {
    setState(() {
      if (_remaining[_currentIndex] > 0) {
        _remaining[_currentIndex]--;
      }
      if (_remaining[_currentIndex] == 0 && _currentIndex < widget.category.items.length - 1) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) {
            _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
          }
        });
      }
    });
  }

  void _resetCurrent() {
    setState(() => _remaining[_currentIndex] = widget.category.items[_currentIndex].repeat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.category.items.length,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            color: AppColors.primary,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.category.items.length,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemBuilder: (context, index) {
          final item = widget.category.items[index];
          final remaining = _remaining[index];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text('${index + 1} / ${widget.category.items.length}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20, height: 1.9),
                  ),
                ),
                if (item.note != null) ...[
                  const SizedBox(height: 12),
                  Text('الفضل: ${item.note}', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                ],
                if (item.source != null) ...[
                  const SizedBox(height: 6),
                  Text(item.source!, style: Theme.of(context).textTheme.bodyMedium),
                ],
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: index == _currentIndex ? _count : null,
                  child: CircularPercentIndicator(
                    radius: 70,
                    lineWidth: 10,
                    percent: item.repeat == 0 ? 0 : (item.repeat - remaining) / item.repeat,
                    progressColor: remaining == 0 ? AppColors.success : AppColors.primary,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      '$remaining',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(remaining == 0 ? 'أحسنت! انتقل للذكر التالي' : 'اضغط للعدّ',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _resetCurrent,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('إعادة'),
                    ),
                    const SizedBox(width: 12),
                    if (index < widget.category.items.length - 1)
                      ElevatedButton.icon(
                        onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('التالي'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
