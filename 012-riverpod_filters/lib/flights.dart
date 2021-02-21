import 'models/flight.dart';

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
