import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_filters/models/flight.dart';

final List<Flight> flightsList = [
  new Flight(
      price: 500, flightClass: 'Economy', tripTitle: 'ATL - LAX', direct: true),
  new Flight(
      price: 800,
      flightClass: 'Business',
      tripTitle: 'DXB - HND',
      direct: true),
  new Flight(
      price: 300, flightClass: 'Economy', tripTitle: 'ORD - LHR', direct: true),
  new Flight(
      price: 440,
      flightClass: 'Economy',
      tripTitle: 'LHR - LAX',
      direct: false),
  new Flight(
      price: 700, flightClass: 'Economy', tripTitle: 'CDG - LAX', direct: true),
  new Flight(
      price: 1800,
      flightClass: 'Business',
      tripTitle: 'CAN - LAX',
      direct: false),
];

final flightsProvider = Provider<List<Flight>>((ref) => flightsList);

final directFilterProvider = StateProvider<bool>((_) => false);
final priceFilterProvider = StateProvider<num>((_) => 0);

final filteredFlights = Provider<List<Flight>>((ref) {
  final flights = ref.watch(flightsProvider);
  final direct = ref.watch(directFilterProvider).state;
  final price = ref.watch(priceFilterProvider).state;

  var filteredFlightsList = flights.where((flight) => flight.direct == direct);

  if (price > 0) {
    filteredFlightsList =
        filteredFlightsList.where((flight) => flight.price < price);
  }

  return filteredFlightsList.toList();
});
