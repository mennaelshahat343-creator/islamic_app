import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/constants/app_colors.dart';
import '../../services/audio_service.dart';

/// مشغل صوتي لتلاوة السورة الكاملة - Play/Pause/Seek/Volume
class QuranPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String surahName;
  final String reciterName;

  const QuranPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.surahName,
    required this.reciterName,
  });

  @override
  State<QuranPlayerWidget> createState() => _QuranPlayerWidgetState();
}

class _QuranPlayerWidgetState extends State<QuranPlayerWidget> {
  final _audio = QuranAudioService.instance;
  bool _loading = false;
  bool _errored = false;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _errored = false;
    });
    try {
      await _audio.playUrl(widget.audioUrl);
    } catch (_) {
      setState(() => _errored = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _audio.stop();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_errored) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            const Expanded(child: Text('تعذّر تحميل الصوت، تحقق من اتصالك بالإنترنت')),
            TextButton(onPressed: _load, child: const Text('إعادة المحاولة')),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12)],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${widget.surahName} - ${widget.reciterName}',
                style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            StreamBuilder<Duration?>(
              stream: _audio.durationStream,
              builder: (context, durationSnap) {
                final duration = durationSnap.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: _audio.positionStream,
                  builder: (context, posSnap) {
                    final position = posSnap.data ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          value: position.inMilliseconds
                              .clamp(0, duration.inMilliseconds == 0 ? 1 : duration.inMilliseconds)
                              .toDouble(),
                          max: duration.inMilliseconds == 0 ? 1 : duration.inMilliseconds.toDouble(),
                          activeColor: AppColors.primary,
                          onChanged: (v) => _audio.seek(Duration(milliseconds: v.toInt())),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_fmt(position), style: Theme.of(context).textTheme.bodyMedium),
                              Text(_fmt(duration), style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volume_down_rounded, color: Theme.of(context).colorScheme.primary),
                SizedBox(
                  width: 100,
                  child: Slider(
                    value: _volume,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      setState(() => _volume = v);
                      _audio.setVolume(v);
                    },
                  ),
                ),
                Icon(Icons.volume_up_rounded, color: Theme.of(context).colorScheme.primary),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 34,
                  icon: const Icon(Icons.replay_10_rounded),
                  onPressed: () => _audio.seek(
                    _audio.player.position - const Duration(seconds: 10),
                  ),
                ),
                const SizedBox(width: 10),
                _loading
                    ? const SizedBox(width: 56, height: 56, child: CircularProgressIndicator())
                    : StreamBuilder<PlayerState>(
                        stream: _audio.playerStateStream,
                        builder: (context, snap) {
                          final playing = snap.data?.playing ?? false;
                          return IconButton(
                            iconSize: 56,
                            color: AppColors.primary,
                            icon: Icon(playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded),
                            onPressed: () => playing ? _audio.pause() : _audio.resume(),
                          );
                        },
                      ),
                const SizedBox(width: 10),
                IconButton(
                  iconSize: 34,
                  icon: const Icon(Icons.forward_10_rounded),
                  onPressed: () => _audio.seek(
                    _audio.player.position + const Duration(seconds: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
