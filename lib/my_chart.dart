import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'time_series_moods.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  const SimpleTimeSeriesChart(this.seriesList);
  final List<charts.Series<TimeSeriesMoods, DateTime>> seriesList;

  @override
  Widget build(BuildContext context) => charts.TimeSeriesChart(
    seriesList,
    customSeriesRenderers: [
      new charts.PointRendererConfig(
        // ID used to link series to this renderer.
          customRendererId: 'customPoint')
    ],
    animate: true,
    defaultRenderer:
    new charts.LineRendererConfig(includeArea: true, stacked: true),
    primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec:
        new charts.BasicNumericTickProviderSpec(desiredTickCount: 21)),
    behaviors: [
      new charts.RangeAnnotation([
        new charts.RangeAnnotationSegment(-100,
            100, charts.RangeAnnotationAxisType.measure),
      ])],
    animationDuration:Duration(milliseconds: 500),
    dateTimeFactory: const charts.LocalDateTimeFactory(),
    domainAxis: charts.DateTimeAxisSpec(
      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
        day: charts.TimeFormatterSpec(
          format: 'dd.MM',
          transitionFormat: 'dd.MM',
        ),hour: charts.TimeFormatterSpec(
        format: 'dd.MM.yy',
        transitionFormat: 'dd.MM',
      ),
        minute: charts.TimeFormatterSpec(
          format: 'dd.MM',
          transitionFormat: 'dd.MM',
        ),
      ),
    ),
  );

}
