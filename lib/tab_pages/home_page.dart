import 'dart:async';
import 'package:cycletech/globals/globaldata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';

import '../utilities/conts.dart';
import '../utilities/quote_generator.dart'; // Import your quote generator

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  late String _quoteOfTheDay;

  late Timer _quoteTimer;

  @override
  void initState() {
    super.initState();
    _quoteOfTheDay = ""; // Initialize with an empty string
    _getLocationAndFetchWeather();
    _setupQuoteTimer();
    _updateQuoteOfTheDay();
  }

  void _setupQuoteTimer() {
    _quoteTimer = Timer.periodic(Duration(days: 1), (_) {
      _updateQuoteOfTheDay();
    });
  }

  Future<void> _getLocationAndFetchWeather() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location') ?? "Bahrain";

    _wf.currentWeatherByCityName(location).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  void _updateQuoteOfTheDay() async {
    String quoteKey = 'quote_of_the_day';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if there's a saved quote
    String? savedQuote = prefs.getString(quoteKey);

    if (savedQuote != null && savedQuote.isNotEmpty) {
      // Use the saved quote
      setState(() {
        _quoteOfTheDay = savedQuote;
      });
    } else {
      // Generate a new quote and save it
      String newQuote = getRandomQuote();
      prefs.setString(quoteKey, newQuote);

      setState(() {
        _quoteOfTheDay = newQuote;
      });
    }
  }

  @override
  void dispose() {
    _quoteTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: currBrightness == Brightness.dark
            ? Colors.black54
            : Colors.blue[100],
        foregroundColor:
            currBrightness == Brightness.dark ? Colors.white : Colors.black54,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // Weather information
            Container(
              height: MediaQuery.of(context).size.height * 0.28,
              color: currBrightness == Brightness.dark
                  ? Colors.grey[700]
                  : Colors.blue[300],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Weather',
                    style: TextStyle(
                      fontSize: 24,
                      color: currBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_weather != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Weather icon
                        _weatherIcon(),
                        const SizedBox(width: 10),
                        // Weather details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location: ${_weather?.areaName ?? ""}',
                                style: TextStyle(
                                  color: currBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              _dateTimeInfo(),
                              Text(
                                'Temperature: ${_weather!.temperature?.celsius?.toStringAsFixed(0)}°C',
                                style: TextStyle(
                                  color: currBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              Text(
                                'Min/Max: ${_weather!.tempMin?.celsius?.toStringAsFixed(0)}°C / ${_weather!.tempMax?.celsius?.toStringAsFixed(0)}°C',
                                style: TextStyle(
                                  color: currBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              Text(
                                'Wind Speed: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s',
                                style: TextStyle(
                                  color: currBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              Text(
                                'Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: currBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ] else ...[
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),

            // Quote of the Day
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quote of the Day',
                    style: TextStyle(
                      fontSize: 24,
                      color: currBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _quoteOfTheDay,
                    style: TextStyle(
                      color: currBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: TextStyle(
            fontSize: 24,
            color: currBrightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: currBrightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                fontSize: 18,
              ),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(now)}",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: currBrightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_weather?.weatherIcon != null)
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Image.network(
              "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@2x.png",
            ),
          ),
        if (_weather?.weatherDescription != null)
          Text(
            _weather!.weatherDescription!,
            style: TextStyle(
              color: currBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (_weather == null || _weather!.weatherIcon == null)
          Text(
            "Weather information not available",
            style: TextStyle(
              color: currBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
