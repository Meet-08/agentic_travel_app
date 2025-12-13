import 'package:genui/genui.dart';
import 'package:travel_app/src/models/hotel_listing.dart';

class HotelSearchResult {
  final List<HotelListing> listings;

  HotelSearchResult({required this.listings});

  static HotelSearchResult fromJson(JsonMap json) {
    return HotelSearchResult(
      listings: (json['listings'] as List)
          .map((e) => HotelListing.fromJson(e as JsonMap))
          .toList(),
    );
  }

  JsonMap toJson() {
    return {'listings': listings.map((e) => e.toJson()).toList()};
  }

  JsonMap toAiInput() {
    return {'listings': listings.map((e) => e.toAiInput()).toList()};
  }
}
