import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: const Weather(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final TextEditingController _cityController = TextEditingController();
  dynamic _weatherData;
  String _icon = '';
  Future<dynamic> getWeather(String city) async {
    String apiKey = '56248e627919785148ca1eb4a37f63ac';
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "How is the weather in ...?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'Enter city',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String city = _cityController.text;
                getWeather(city).then((weatherData) {
                  setState(() {
                    _weatherData = weatherData;
                    _icon = weatherData['weather'][0]['icon'];
                  });
                });
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20.0),
            if (_weatherData != null)
              Column(
                children: [
                  Text(
                    'Temperature: ${_weatherData['main']['temp']}°C',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10.0),
                  Image.network(
                    'https://openweathermap.org/img/w/$_icon.png',
                    width: 100,
                    height: 100,
                  ),
                  Text('Location: ${_weatherData['name']}'),
                  const SizedBox(height: 15.0),
                  Text('Country: ${_weatherData['sys']['country']}'),
                  const SizedBox(height: 15.0),
                  Text('Wind Speed: ${_weatherData['wind']['speed']}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
