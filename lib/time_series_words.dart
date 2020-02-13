class TimeSeriesWords {
  TimeSeriesWords(this.time, this.words);

  final DateTime time;
  final String words;

  factory TimeSeriesWords.fromJson(dynamic json) {
    return TimeSeriesWords(json['time'] as DateTime, json['words'] as String);
  }

  @override
  String toString() {
    return '{ ${this.time}, ${this.words} }';
  }
}

