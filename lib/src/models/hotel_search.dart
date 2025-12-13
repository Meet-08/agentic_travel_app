import 'package:genui/genui.dart';

class HotelSearch {
  final String query;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  HotelSearch({
    required this.query,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  static HotelSearch fromJson(JsonMap json) {
    return HotelSearch(
      query: json['query'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      guests: json['guests'] as int,
    );
  }

  JsonMap toJson() {
    return {
      'query': query,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
    };
  }
}
