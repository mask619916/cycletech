import 'dart:async';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/utilities/quote_generator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import '../utilities/conts.dart';

class HomePage extends StatefulWidget {
  String quoteOfTheDay;

  HomePage({Key? key, this.quoteOfTheDay = ""}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;

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
                fontWeight: FontWeight.bold,
                color: currBrightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return _weather?.weatherIcon != null
        ? Column(
            children: [
              Image.network(
                "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@2x.png",
                scale: 0.7,
              ),
              Text(
                _weather!.weatherMain ?? "Weather information not available",
                style: TextStyle(
                  color: currBrightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        : Text(
            "Weather information not available",
            style: TextStyle(
              color: currBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
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

  @override
  void initState() {
    super.initState();

    if (widget.quoteOfTheDay.isEmpty) {
      // This means it's the first run for a new user
      _updateQuoteOfTheDay();
    }

    _getLocationAndFetchWeather();
  }

  void _updateQuoteOfTheDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String quoteKey = 'quote_of_the_day';

    // Generate a new quote and save it
    String newQuote = getRandomQuote();
    prefs.setString(quoteKey, newQuote);

    // Set the quoteOfTheDay to the new quote
    setState(() {
      widget.quoteOfTheDay = newQuote;
    });
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Weather information
              Container(
                decoration: BoxDecoration(
                  color: currBrightness == Brightness.dark
                      ? Colors.grey[700]
                      : Colors.blue[300],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
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
                          _weatherIcon(),
                          const SizedBox(width: 10),
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

              const SizedBox(height: 16),

              // Quote of the Day
              Container(
                decoration: BoxDecoration(
                  color: currBrightness == Brightness.dark
                      ? Colors.green[700]
                      : Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
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
                      widget.quoteOfTheDay,
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
      ),
    );
  }
}
