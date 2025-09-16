import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';

class StaticMarketScreen extends StatelessWidget {
  final List<FlSpot> samplePriceData = [
    FlSpot(0, 1200),
    FlSpot(1, 1250),
    FlSpot(2, 1300),
    FlSpot(3, 1280),
    FlSpot(4, 1350),
    FlSpot(5, 1380),
    FlSpot(6, 1400),
  ];

  final Map<String, dynamic> sampleWeather = {
    'temperature': 28,
    'rain': 10,
    'humidity': 75,
  };

  final String location = "Bangalore, Karnataka";

  final List<Map<String, dynamic>> sampleMarketTrends = [
    {'crop': 'Tomatoes', 'price': '₹25/kg', 'trend': 'Rising'},
    {'crop': 'Potatoes', 'price': '₹15/kg', 'trend': 'Stable'},
    {'crop': 'Onions', 'price': '₹20/kg', 'trend': 'Falling'},
    {'crop': 'Carrots', 'price': '₹30/kg', 'trend': 'Stable'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market & Weather').tr(),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location: $location',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              SizedBox(height: 20),

              Text('Price Trends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).tr(),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: samplePriceData,
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text('Weather Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).tr(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _weatherBox('Temperature', '${sampleWeather['temperature']}°C', Colors.orange),
                  _weatherBox('Rain', '${sampleWeather['rain']} mm', Colors.blue),
                  _weatherBox('Humidity', '${sampleWeather['humidity']}%', Colors.green),
                ],
              ),
              SizedBox(height: 20),

              Text('Market Crop Trends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).tr(),
              SizedBox(height: 10),
              Column(
                children: sampleMarketTrends.map((trend) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(Icons.local_grocery_store, color: Colors.green[700]),
                      title: Text(trend['crop']),
                      subtitle: Text('Price: ${trend['price']}'),
                      trailing: Text(
                        trend['trend'],
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800]),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),
              _plantingIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weatherBox(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  Widget _plantingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Good Planting Day', style: TextStyle(fontWeight: FontWeight.bold)).tr(),
        ],
      ),
    );
  }
}
