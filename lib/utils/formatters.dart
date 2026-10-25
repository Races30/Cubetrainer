class Formatters {
  static String formatTime(int ms) {
    if (ms < 0) return '0.00';
    int minutes = ms ~/ 60000;
    int seconds = (ms % 60000) ~/ 1000;
    int hundredths = (ms % 1000) ~/ 10;

    if (minutes > 0) {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}.${hundredths.toString().padLeft(2, '0')}';
    }
    return '${seconds}.${hundredths.toString().padLeft(2, '0')}';
  }
}
