class TimeSeriesMoods {
  TimeSeriesMoods(this.time, this.value);

  final DateTime time;
  final int value;

  factory TimeSeriesMoods.fromJson(dynamic json) {
    return TimeSeriesMoods(json['time'] as DateTime, json['value'] as int);
  }

  @override
  String toString() {
    return '{ ${this.time}, ${this.value} }';
  }
}