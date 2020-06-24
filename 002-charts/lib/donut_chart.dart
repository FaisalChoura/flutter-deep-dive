/// Donut chart example. This is a simple pie chart with a hole in the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData() {
    return new DonutPieChart(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(arcWidth: 15),
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.middleDrawArea,
          horizontalFirst: true,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          desiredMaxColumns: 2,
          desiredMaxRows: 2,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : "${value}\$";
          },
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              fontFamily: 'Roboto',
              fontSize: 16),
          // insideJustification: InsideJustification.topEnd,
        ),
      ],
      selectionModels: [
        new charts.SelectionModelConfig(changedListener: (selectionModel) {
          final selectedData = selectionModel.selectedDatum;

          if (selectedData.isNotEmpty) {
            final purchases = selectedData.first.datum.amount;
            print(purchases);
          }
        }),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Purchases, String>> _createSampleData() {
    final data = [
      new Purchases("Eating Out", 100, charts.Color(r: 255, g: 89, b: 100)),
      new Purchases("Groceries", 75, charts.Color(r: 89, g: 255, b: 89)),
      new Purchases("Shopping", 25, charts.Color(r: 89, g: 216, b: 255)),
      new Purchases("Traveling", 5, charts.Color(r: 255, g: 166, b: 89)),
    ];

    return [
      new charts.Series<Purchases, String>(
        id: 'purchases',
        domainFn: (Purchases purchases, _) => purchases.category,
        measureFn: (Purchases purchases, _) => purchases.amount,
        data: data,
        colorFn: (Purchases purchases, _) => purchases.color,
      )
    ];
  }
}

class Purchases {
  final String category;
  final num amount;
  final charts.Color color;
  Purchases(this.category, this.amount, this.color);
}
