import 'package:just_audio/just_audio.dart';

/// خدمة تشغيل الصوت - تُستخدم لتلاوة القرآن الكريم وصوت الأذان
class QuranAudioService {
  static final QuranAudioService instance = QuranAudioService._internal();
  QuranAudioService._internal();

  final AudioPlayer player = AudioPlayer();

  Future<void> playUrl(String url) async {
    await player.setUrl(url);
    await player.play();
  }

  Future<void> pause() => player.pause();
  Future<void> resume() => player.play();
  Future<void> stop() => player.stop();
  Future<void> seek(Duration position) => player.seek(position);
  Future<void> setVolume(double volume) => player.setVolume(volume);

  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;
  Stream<PlayerState> get playerStateStream => player.playerStateStream;

  void dispose() => player.dispose();
}
