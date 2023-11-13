import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class ChartData {
  final DateTime date;
  final int? good;
  final int? bad;
  final charts.Color barColorGood;
  final charts.Color barColorBad;


  ChartData(this.date, this.good, this.bad, this.barColorGood, this.barColorBad);
}

class DatabaseService {
  final DatabaseReference _reviewRef = FirebaseDatabase.instance.ref().child("reviews");

  Future<Map<DateTime, Map<String, int>>> fetchReviewData() async {
    Map<DateTime, Map<String, int>> reviewData = {};

    DatabaseEvent event = await _reviewRef.once();
    List<dynamic> values = event.snapshot.value as List<dynamic>;

    values.forEach((item) {
      if(item != null) {
        String dateString = item['date'];
        List<String> dateParts = dateString.split(':');
        String formattedDateString = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
        DateTime date = DateTime.parse(formattedDateString);
        String rate = item['rate'];
        if (reviewData[date] == null) {
          reviewData[date] = {'good': 0, 'bad': 0};
        }

        if (reviewData[date] != null){
          if(reviewData[date]![rate] != null){
            reviewData[date]![rate] = (reviewData[date]![rate] ?? 0) + 1;
          }
        }
      }
    });
    return reviewData;

  }

  Future<List<ChartData>> fetchChartData() async {

    Map<DateTime, Map<String, int>> reviewData = await fetchReviewData();

    print('Fetched review data: $reviewData');  // Add this line

    List<ChartData> chartData = [];
    reviewData.forEach((date, data) {
      chartData.add(
        ChartData(
            date,
            data['good'],
            data['bad'],
            charts.ColorUtil.fromDartColor(Colors.blue),
            charts.ColorUtil.fromDartColor(Colors.red)
        ),
      );
    });

    return chartData;
  }

}

class MyChart extends StatelessWidget {
  final List<ChartData> data;

  MyChart({required this.data});

  @override
  Widget build(BuildContext context) {

    List<charts.Series<ChartData, DateTime>> series = [
      charts.Series(
        id: 'Good',
        data: data,
        domainFn: (ChartData occurrence, _) => occurrence.date,
        measureFn: (ChartData occurrence, _) => occurrence.good,
        colorFn: (ChartData occurrence, _) => occurrence.barColorGood,
      ),
      charts.Series(
        id: 'Bad',
        data: data,
        domainFn: (ChartData occurrence, _) => occurrence.date,
        measureFn: (ChartData occurrence, _) => occurrence.bad,
        colorFn: (ChartData occurrence, _) => occurrence.barColorBad,
      ),
    ];

    return charts.TimeSeriesChart(
        series,
      // Use LineRendererConfig with custom areaRendererId.
      // customSeriesRenderers: [
      //   charts.LineRendererConfig(
      //     customRendererId: 'goodAreaRenderer',
      //     // Optional, use area renderer.
      //     includeArea: true,
      //     stacked: true,
      //   ),
      //   charts.LineRendererConfig(
      //     customRendererId: 'badAreaRenderer',
      //     // Optional, use area renderer.
      //     includeArea: true,
      //     stacked: true,
      //   ),
      // ],
    );
  }
}


class Review_Graph extends StatefulWidget {
  const Review_Graph({Key? key}) : super(key: key);

  @override
  State<Review_Graph> createState() => _Review_GraphState();
}

class _Review_GraphState extends State<Review_Graph> {
  DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChartData>>(
      future: dbService.fetchChartData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyChart(data: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}

// class ChartData {
//   final String date;
//   final int? good;
//   final int? bad;
//
//   ChartData(this.date, this.good, this.bad);
// }
//
// class MyChart extends StatelessWidget {
//   final List<ChartData> data;
//
//   MyChart({required this.data});
//
//   List<charts.Series<ChartData, String>> _createSeries(List<ChartData> chartData) {
//     return [
//       charts.Series<ChartData, String>(
//         id: 'Good',
//         domainFn: (ChartData occurrence, _) => occurrence.date,
//         measureFn: (ChartData occurrence, _) => occurrence.good,
//         data: chartData,
//         colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
//       ),
//       charts.Series<ChartData, String>(
//         id: 'Bad',
//         domainFn: (ChartData occurrence, _) => occurrence.date,
//         measureFn: (ChartData occurrence, _) => occurrence.bad,
//         data: chartData,
//         colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
//       )
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return charts.BarChart(
//       _createSeries(data),
//       animate: true,
//       barGroupingType: charts.BarGroupingType.grouped,
//     );
//   }
// }
//
// class Review_Graph extends StatefulWidget {
//   const Review_Graph({Key? key}) : super(key: key);
//
//   @override
//   State<Review_Graph> createState() => _Review_GraphState();
// }
//
// class _Review_GraphState extends State<Review_Graph> {
//   DatabaseService dbService = DatabaseService();
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ChartData>>(
//       future: dbService.fetchChartData(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return MyChart(data: snapshot.data!.map((e) => ChartData(e.date.toString(), e.good, e.bad)).toList());
//         } else if (snapshot.hasError) {
//           return Text("${snapshot.error}");
//         }
//
//         return CircularProgressIndicator();
//       },
//     );
//   }
// }