import 'package:genui/genui.dart';
import 'package:travel_app/src/catalog/itinerary/itinerary.schema.dart';

extension type ItineraryData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap get subheading => _json['subheading'] as JsonMap;
  String get imageChildId => _json['imageChildId'] as String;
  List<JsonMap> get days => (_json['days'] as List).cast<JsonMap>();
}

extension type ItineraryDayData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap get subtitle => _json['subtitle'] as JsonMap;
  JsonMap get description => _json['description'] as JsonMap;
  String get imageChildId => _json['imageChildId'] as String;
  List<JsonMap> get entries => (_json['entries'] as List).cast<JsonMap>();
}

extension type ItineraryEntryData.fromMap(Map<String, Object?> _json) {
  JsonMap get title => _json['title'] as JsonMap;
  JsonMap? get subtitle => _json['subtitle'] as JsonMap?;
  JsonMap get bodyText => _json['bodyText'] as JsonMap;
  JsonMap? get address => _json['address'] as JsonMap?;
  JsonMap get time => _json['time'] as JsonMap;
  JsonMap? get totalCost => _json['totalCost'] as JsonMap?;
  ItineraryEntryType get type =>
      ItineraryEntryType.values.byName(_json['type'] as String);
  ItineraryEntryStatus get status =>
      ItineraryEntryStatus.values.byName(_json['status'] as String);
  JsonMap? get choiceRequiredAction =>
      _json['choiceRequiredAction'] as JsonMap?;
}
