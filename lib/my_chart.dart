import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'time_series_moods.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
class SimpleTimeSeriesChart extends StatelessWidget {
   SimpleTimeSeriesChart(this.seriesList);
  final List<charts.Series<TimeSeriesMoods, DateTime>> seriesList;

  @override
  Widget build(BuildContext context) => charts.TimeSeriesChart(
    seriesList,
    customSeriesRenderers: [
      new charts.PointRendererConfig(
        // ID used to link series to this renderer.
          customRendererId: 'customPoint')
    ],
    selectionModels: [
      SelectionModelConfig(
          changedListener: (SelectionModel model) {
            if(model.hasDatumSelection)
              print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
              //getselectedPoint(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
          }
      )
    ],
    animate: true,

    defaultRenderer:
    new charts.LineRendererConfig(includeArea: true, stacked: true),
    primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec:
        new charts.BasicNumericTickProviderSpec(desiredTickCount: 21)),
    behaviors: [
      LinePointHighlighter(
          symbolRenderer: CustomCircleSymbolRenderer()
      ),
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

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds, {List<int> dashPattern, Color fillColor, Color strokeColor, double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10, bounds.height + 10),
        fill: Color.white
    );
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement("1", style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round()
    );
  }
}


