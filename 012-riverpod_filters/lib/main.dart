import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
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

class FlightPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    List<Flight> flights = watch(flightsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Flights')),
      body: ListView.builder(
        itemCount: flights.length,
        itemBuilder: (BuildContext context, int index) {
          final flight = flights[index];
          return ListTile(
            title: Text(flight.tripTitle),
            subtitle: Text(
                '${flight.flightClass} - ${flight.price} USD - direct: ${flight.direct}'),
          );
        },
      ),
    );
  }
}
