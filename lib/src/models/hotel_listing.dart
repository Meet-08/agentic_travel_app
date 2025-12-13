import 'package:genui/genui.dart';
import 'package:travel_app/src/models/hotel_search.dart';
import 'package:travel_app/src/models/listing.dart';

class HotelListing implements Listing {
  final String name;
  final String location;
  final double pricePerNight;
  final List<String> images;
  final HotelSearch search;

  @override
  final String listingSelectionId;

  HotelListing({
    required this.name,
    required this.location,
    required this.pricePerNight,
    required this.listingSelectionId,
    required this.images,
    required this.search,
  });

  late final String description =
      '$name in $location, \$${pricePerNight.ceil()}';

  static HotelListing fromJson(JsonMap json) {
    return HotelListing(
      name: json['name'] as String,
      location: json['location'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      listingSelectionId: json['listingSelectionId'] as String,
      search: HotelSearch.fromJson(json['search'] as JsonMap),
    );
  }

  JsonMap toJson() {
    return {
      'name': name,
      'location': location,
      'pricePerNight': pricePerNight,
      'images': images,
      'listingSelectionId': listingSelectionId,
      'search': search.toJson(),
    };
  }

  JsonMap toAiInput() {
    return {
      'description': description,
      'images': images,
      'listingSelectionId': listingSelectionId,
    };
  }
}
