import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:riverpod_filters/filters.dart';
import 'package:riverpod_filters/models/flight.dart';
import 'package:riverpod_filters/providers.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FlightPage(),
    );
  }
}

class FlightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flights')),
      drawer: Drawer(
        child: Filters(),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          List<Flight> flights = watch(filteredFlights);
          return ListView.builder(
            itemCount: flights.length,
            itemBuilder: (BuildContext context, int index) {
              final flight = flights[index];
              return ListTile(
                title: Text(flight.tripTitle),
                subtitle: Text(
                    '${flight.flightClass} - ${flight.price} USD - direct: ${flight.direct}'),
              );
            },
          );
        },
      ),
    );
  }
}
