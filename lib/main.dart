import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final String apiKey = "88658c8bf7mshe105e8d6603a280p1ce7bcjsne2fa0861acb6";
  final String city = "New York";
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final Uri apiUrl = Uri.parse("https://weather-by-api-ninjas.p.rapidapi.com/v1/weather?city=$city");

    final response = await http.get(
      apiUrl,
      headers: {
        "X-RapidAPI-Key": apiKey,
        "X-RapidAPI-Host": "weather-by-api-ninjas.p.rapidapi.com",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weatherData = data;
      });
      print('HTTP Response: $data');
    } else {
      // Handle HTTP errors
      print('HTTP Error: ${response.statusCode}, ${response.reasonPhrase}');
      print('HTTP Error Response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: weatherData == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'City: $city',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Temperature: ${weatherData!['temp']}°C',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Feels Like: ${weatherData!['feels_like']}°C',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Humidity: ${weatherData!['humidity']}%',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Wind Speed: ${weatherData!['wind_speed']} m/s',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Sunrise: ${DateTime.fromMillisecondsSinceEpoch(weatherData!['sunrise'] * 1000)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Sunset: ${DateTime.fromMillisecondsSinceEpoch(weatherData!['sunset'] * 1000)}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
