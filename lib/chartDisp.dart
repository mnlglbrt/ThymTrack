/*
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'data.dart';
import 'timeSeriesMoods.dart';



class SimpleTimeSeriesChart extends StatelessWidget {
  const SimpleTimeSeriesChart(this.seriesList);

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return SimpleTimeSeriesChart(
      _createSampleData(),
    );
  }

  final List<charts.Series<TimeSeriesMoods, DateTime>> seriesList;

  @override
  Widget build(BuildContext context) => charts.TimeSeriesChart(
    seriesList,
    animate: false,
    dateTimeFactory: const charts.LocalDateTimeFactory(),
    domainAxis: charts.DateTimeAxisSpec(
      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
        day: charts.TimeFormatterSpec(
          format: 'EEE',
          transitionFormat: 'EEE',
        ),
      ),
    ),
  );

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesMoods, DateTime>> _createSampleData() {
    return <charts.Series<TimeSeriesMoods, DateTime>>[
      charts.Series<TimeSeriesMoods, DateTime>(
        id: 'Moods',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesMoods moods, _) => moods.time,
        measureFn: (TimeSeriesMoods moods, _) => moods.value,
        data: selectedData,
      )
    ];
  }
}

*/
