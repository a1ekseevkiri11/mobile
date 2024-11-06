import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:weather_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        title: 'Погода',
        theme: dartTheme,
        home: const WeatherScreen(),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _selectedCity = 'Москва';

  final Map<String, List<double>> cityCoordinates = {
    'Москва': [55.7558, 37.6173],
    'Санкт-Петербург': [59.9343, 30.3351],
    'Новосибирск': [55.0084, 82.9357],
    'Екатеринбург': [56.8389, 60.6057],
    'Казань': [55.8304, 49.0661],
    'Владивосток': [43.1197, 131.8855],
    'Самара': [53.1951, 50.1000],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeather();
    });
  }
  

  void _loadWeather() {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    final coordinates = cityCoordinates[_selectedCity]!;
    weatherProvider.loadWeather(coordinates[0], coordinates[1]);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Погода"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _showCityPicker(context);
                  },
                  child: Text(
                    'Выберите город: $_selectedCity',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              if (weatherProvider.currentWeather != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${weatherProvider.currentWeather!.temperature}°C",
                      style: const TextStyle(fontSize: 36),
                    ),
                    Text(
                      weatherProvider.getWeatherEmoji(
                          weatherProvider.currentWeather!.weatherCode),
                      style: const TextStyle(fontSize: 80),
                    ),
                  ],
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
              _buildWeatherCard(
                  "Утро", weatherProvider.morningWeather, weatherProvider),
              _buildWeatherCard(
                  "День", weatherProvider.dayWeather, weatherProvider),
              _buildWeatherCard(
                  "Вечер", weatherProvider.eveningWeather, weatherProvider),
              _buildWeatherCard(
                  "Ночь", weatherProvider.nightWeather, weatherProvider),
            ],
          ),
        ),
      ),
    );
  }

  void _showCityPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: cityCoordinates.keys.map((city) {
                return ListTile(
                  title: Center(
                    child: Text(
                      city,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedCity = city;
                    });
                    Navigator.pop(context);
                    _loadWeather();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherCard(
      String timeOfDay, Weather? weather, WeatherProvider weatherProvider) {
    if (weather == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text('$timeOfDay: Нет данных', style: TextStyle(fontSize: 24)),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListTile(
        title: Text(
          '$timeOfDay: ${weather.temperature}°C',
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          weatherProvider.getWeatherEmoji(weather.weatherCode),
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class WeatherProvider with ChangeNotifier {
  Weather? _currentWeather;
  Weather? _morningWeather;
  Weather? _dayWeather;
  Weather? _eveningWeather;
  Weather? _nightWeather;

  final WeatherService _weatherService = WeatherService();

  Weather? get currentWeather => _currentWeather;
  Weather? get morningWeather => _morningWeather;
  Weather? get dayWeather => _dayWeather;
  Weather? get eveningWeather => _eveningWeather;
  Weather? get nightWeather => _nightWeather;

  Future<void> loadWeather(double latitude, double longitude) async {
    try {
      final data = await _weatherService.fetchWeather(latitude, longitude);
      DateTime now = DateTime.now();
      _currentWeather = Weather.fromJson(data, now.hour);
      _morningWeather = Weather.fromJson(data, 6);
      _dayWeather = Weather.fromJson(data, 12);
      _eveningWeather = Weather.fromJson(data, 18);
      _nightWeather = Weather.fromJson(data, 23);
      notifyListeners();
    } catch (e) {
      _currentWeather = null;
      _morningWeather = null;
      _dayWeather = null;
      _eveningWeather = null;
      _nightWeather = null;
      notifyListeners();
    }
  }

  String getWeatherEmoji(int code) {
    switch (code) {
      case 0:
        return "☀️";
      case 1:
      case 2:
      case 3:
        return "🌤️";
      case 45:
      case 48:
        return "🌫️";
      case 51:
      case 53:
      case 55:
        return "🌦️";
      case 56:
      case 57:
        return "❄️";
      case 61:
      case 63:
      case 65:
        return "🌧️";
      case 66:
      case 67:
        return "❄️";
      case 71:
      case 73:
      case 75:
        return "❄️";
      case 77:
        return "❄️";
      case 80:
      case 81:
      case 82:
        return "🌧️";
      case 85:
      case 86:
        return "❄️";
      case 95:
        return "⛈️";
      case 96:
      case 99:
        return "⛈️";
      default:
        return "❓";
    }
  }
}

class Weather {
  final double temperature;
  final int weatherCode;

  Weather({required this.temperature, required this.weatherCode});

  factory Weather.fromJson(Map<String, dynamic> json, int index) {
    return Weather(
      temperature: json['hourly']['temperature_2m'][index].toDouble(),
      weatherCode: json['hourly']['weather_code'][index],
    );
  }
}

class WeatherService {
  Future<Map<String, dynamic>> fetchWeather(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,weather_code&forecast_days=1',
    ));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Ошибка загрузки данных погоды");
    }
  }
}
