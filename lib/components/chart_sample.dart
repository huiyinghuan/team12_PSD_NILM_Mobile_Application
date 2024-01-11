import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// all sorts of helping tools to allow displaying of bar graph, line graph, pie chart

// for app assets, colors, dimens, urls
class AppAssets {
  static String getChartIcon(ChartType type) {
    switch (type) {
      case ChartType.line:
        return 'assets/icons/ic_line_chart.svg';
      case ChartType.bar:
        return 'assets/icons/ic_bar_chart.svg';
      case ChartType.pie:
        return 'assets/icons/ic_pie_chart.svg';
      case ChartType.scatter:
        return 'assets/icons/ic_scatter_chart.svg';
      case ChartType.radar:
        return 'assets/icons/ic_radar_chart.svg';
    }
  }

  static const flChartLogoIcon = 'assets/icons/fl_chart_logo_icon.png';
  static const flChartLogoText = 'assets/icons/fl_chart_logo_text.svg';
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class AppDimens {
  static const double menuMaxNeededWidth = 304;
  static const double menuRowHeight = 74;
  static const double menuIconSize = 32;
  static const double menuDocumentationIconSize = 44;
  static const double menuTextSize = 20;

  static const double chartBoxMinWidth = 350;

  static const double defaultRadius = 8;
  static const double chartSamplesSpace = 32.0;
  static const double chartSamplesMinWidth = 350;
}

class Urls {
  static const flChartUrl = 'https://flchart.dev';
  static const flChartGithubUrl = 'https://github.com/imaNNeo/fl_chart';

  static String get aboutUrl => '$flChartUrl/about';

  static String getChartSourceCodeUrl(ChartType chartType, int sampleNumber) {
    final chartDir = chartType.name.toLowerCase();
    return 'https://github.com/imaNNeo/fl_chart/blob/main/example/lib/presentation/samples/$chartDir/${chartDir}_chart_sample$sampleNumber.dart';
  }

  static String getChartDocumentationUrl(ChartType chartType) {
    final chartDir = chartType.name.toLowerCase();
    return 'https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/${chartDir}_chart.md';
  }

  static String getVersionReleaseUrl(String version) =>
      '$flChartGithubUrl/releases/tag/$version';
}

// for legend widget - barchart
class LegendWidget extends StatelessWidget {
  const LegendWidget({
    super.key,
    required this.name,
    required this.color,
  });
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  const LegendsListWidget({
    super.key,
    required this.legends,
  });
  final List<Legend> legends;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
              name: e.name,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class Legend {
  Legend(this.name, this.color);
  final String name;
  final Color color;
}

// for indicator - piechart
class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

// for chart type widget
enum ChartType { line, bar, pie, scatter, radar }

extension ChartTypeExtension on ChartType {
  String get displayName => '$simpleName Chart';

  String get simpleName => switch (this) {
        ChartType.line => 'Line',
        ChartType.bar => 'Bar',
        ChartType.pie => 'Pie',
        ChartType.scatter => 'Scatter',
        ChartType.radar => 'Radar',
      };

  String get documentationUrl => Urls.getChartDocumentationUrl(this);

  String get assetIcon => AppAssets.getChartIcon(this);
}

abstract class ChartSample {
  final int number;
  final WidgetBuilder builder;
  ChartType get type;
  String get name => '${type.displayName} Sample $number';
  String get url => Urls.getChartSourceCodeUrl(type, number);
  ChartSample(this.number, this.builder);
}

class LineChartSample extends ChartSample {
  LineChartSample(super.number, super.builder);
  @override
  ChartType get type => ChartType.line;
}

class BarChartSample extends ChartSample {
  BarChartSample(super.number, super.builder);
  @override
  ChartType get type => ChartType.bar;
}

class PieChartSample extends ChartSample {
  PieChartSample(super.number, super.builder);
  @override
  ChartType get type => ChartType.pie;
}

class ScatterChartSample extends ChartSample {
  ScatterChartSample(super.number, super.builder);
  @override
  ChartType get type => ChartType.scatter;
}

class RadarChartSample extends ChartSample {
  RadarChartSample(super.number, super.builder);
  @override
  ChartType get type => ChartType.radar;
}