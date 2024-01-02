// Import necessary packages
import 'dart:async';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/utilities/conts.dart';
import 'package:cycletech/utilities/firebase_controller.dart';
import 'package:cycletech/utilities/quote_generator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Define the HomePage widget
class HomePage extends StatefulWidget {
  String quoteOfTheDay;

  HomePage({
    Key? key,
    this.quoteOfTheDay = "",
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Define the state for the HomePage widget
class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;

  // Widget to display date and time information
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

  // Widget to display weather icon and information
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

  // Function to get location and fetch weather information
  Future<void> _getLocationAndFetchWeather() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location') ?? "Bahrain";

    _wf.currentWeatherByCityName(location).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  // Function to update the quote of the day
  void _updateQuoteOfTheDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String quoteKey = 'quote_of_the_day';

    String newQuote = getRandomQuote();
    prefs.setString(quoteKey, newQuote);

    if (!mounted) return;
    setState(() {
      widget.quoteOfTheDay = newQuote;
    });
  }

  // Initialization function
  @override
  void initState() {
    super.initState();

    if (widget.quoteOfTheDay.isEmpty) {
      _updateQuoteOfTheDay();
    }

    _getLocationAndFetchWeather();
  }

  // Build function to create the widget tree
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
      // Removed Expanded widget
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container for Weather information
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
                  // Check if weather information is available
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

            // Container for Quote of the Day
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: 16),

            // Container for User Information
            Container(
              decoration: BoxDecoration(
                color: currBrightness == Brightness.dark
                    ? Colors.blue[900]
                    : Colors.blue[100],
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Personal Best',
                    style: TextStyle(
                      fontSize: 24,
                      color: currBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // FutureBuilder to fetch user data from Firestore
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser?.email)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text('User data not available');
                      } else {
                        var userData = snapshot.data!;

                        // Replace 'field_name_here' with the actual field names from your Firestore document
                        String fName = userData['fName'] ?? 'N/A';
                        String lName = userData['lName'] ?? 'N/A';
                        String highestDistance = '';
                        String highestDurInHour = '';
                        String highestDurInMin = '';

                        // Fetch the longest ride information
                        FirebaseController.getLongestRide(
                                userEmail: userData['email'])
                            .then((value) {
                          highestDurInHour = value.inHours.toString();
                          highestDurInMin =
                              value.inMinutes.remainder(60).toString();
                        });

                        // FutureBuilder to fetch highest distance
                        return FutureBuilder<double>(
                          future: FirebaseController.getHighestDistance(
                            userEmail: userData['email'],
                          ),
                          builder: (context, distanceSnapshot) {
                            if (distanceSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (distanceSnapshot.hasError) {
                              return Text('Error: ${distanceSnapshot.error}');
                            } else {
                              highestDistance =
                                  distanceSnapshot.data?.toStringAsFixed(0) ??
                                      '0';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Name: $fName $lName',
                                    style: TextStyle(
                                      color: currBrightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'PB Distance: ${highestDistance} Meters',
                                    style: TextStyle(
                                      color: currBrightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'Longest Duration: $highestDurInHour hour(s) and $highestDurInMin min(s)',
                                    style: TextStyle(
                                      color: currBrightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
