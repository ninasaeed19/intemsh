import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Analytics'),
      ),
      // Use a ListView to prevent overflow on smaller screens or with more content.
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          AnalyticsChartCard(
            title: 'Monthly Event Attendance',
            chart: EventAttendanceChart.withSampleData(),
          ),
          const SizedBox(height: 24),
          AnalyticsChartCard(
            title: 'Event Types Distribution',
            chart: EventTypePieChart.withSampleData(),
          ),
          const SizedBox(height: 24),
          const SummaryCards(),
        ],
      ),
    );
  }
}

/// A reusable card widget to display a chart with a title.
class AnalyticsChartCard extends StatelessWidget {
  final String title;
  final Widget chart;

  const AnalyticsChartCard({
    super.key,
    required this.title,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            chart,
          ],
        ),
      ),
    );
  }
}

/// A horizontal bar chart showing event attendance per month.
class EventAttendanceChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  const EventAttendanceChart(this.seriesList, {super.key, this.animate = true});

  factory EventAttendanceChart.withSampleData() {
    return EventAttendanceChart(_createSampleData());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: charts.BarChart(
        seriesList,
        animate: animate,
        vertical: false, // For a horizontal bar chart
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      ),
    );
  }

  static List<charts.Series<_EventData, String>> _createSampleData() {
    final data = [
      _EventData('Jan', 5),
      _EventData('Feb', 8),
      _EventData('Mar', 12),
      _EventData('Apr', 7),
      _EventData('May', 15),
    ];

    return [
      charts.Series<_EventData, String>(
        id: 'Events',
        domainFn: (_EventData data, _) => data.month,
        measureFn: (_EventData data, _) => data.count,
        data: data,
        labelAccessorFn: (_EventData data, _) => '${data.count} Events',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }
}

/// A pie chart showing the distribution of different event types.
class EventTypePieChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  const EventTypePieChart(this.seriesList, {super.key, this.animate = true});

  factory EventTypePieChart.withSampleData() {
    return EventTypePieChart(_createSampleData());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: charts.PieChart<String>(
        seriesList,
        animate: animate,
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 60,
          arcRendererDecorators: [
            charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.auto,
            )
          ],
        ),
        // Add a legend for better readability
        behaviors: [
          charts.DatumLegend(
            position: charts.BehaviorPosition.end,
            horizontalFirst: false,
            cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
            showMeasures: true,
            legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
            measureFormatter: (num? value) {
              return value == null ? '-' : '$value%';
            },
          ),
        ],
      ),
    );
  }

  static List<charts.Series<_EventTypeData, String>> _createSampleData() {
    final data = [
      _EventTypeData('Workshop', 35, charts.MaterialPalette.blue.shadeDefault),
      _EventTypeData('Seminar', 25, charts.MaterialPalette.green.shadeDefault),
      _EventTypeData('Social', 40, charts.MaterialPalette.deepOrange.shadeDefault),
    ];

    return [
      charts.Series<_EventTypeData, String>(
        id: 'Event Types',
        domainFn: (_EventTypeData data, _) => data.type,
        measureFn: (_EventTypeData data, _) => data.percentage,
        colorFn: (_EventTypeData data, _) => data.color,
        data: data,
        labelAccessorFn: (_EventTypeData data, _) => '${data.percentage}%',
      )
    ];
  }
}

/// A row of cards displaying summary statistics.
class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
              'Total Events', '47', Colors.blue.shade700, Icons.event
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
              'Participants', '1,234', Colors.green.shade700, Icons.people
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
              'Avg. Attendance', '26', Colors.orange.shade800, Icons.bar_chart
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// Private data holder class for the bar chart.
class _EventData {
  final String month;
  final int count;
  _EventData(this.month, this.count);
}

/// Private data holder class for the pie chart.
class _EventTypeData {
  final String type;
  final int percentage;
  final charts.Color color;
  _EventTypeData(this.type, this.percentage, this.color);
}
