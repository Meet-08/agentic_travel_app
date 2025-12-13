import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:travel_app/src/models/hotel_search.dart';
import 'package:travel_app/src/models/hotel_search_result.dart';

class ListHotelsService extends AiTool<Map<String, Object?>> {
  ListHotelsService({required this.onListHotels})
    : super(
        name: 'listHotels',
        description: 'Lists hotels based on the provided criteria.',
        parameters: S.object(
          properties: {
            'query': S.string(
              description: 'The search query, e.g., "hotels in Paris".',
            ),
            'checkIn': S.string(
              description: 'The check-in date in ISO 8601 format (YYYY-MM-DD).',
              format: 'date',
            ),
            'checkOut': S.string(
              description:
                  'The check-out date in ISO 8601 format (YYYY-MM-DD).',
              format: 'date',
            ),
            'guests': S.integer(
              description: 'The number of guests.',
              minimum: 1,
            ),
          },
          required: ['query', 'checkIn', 'checkOut', 'guests'],
        ),
      );

  /// The callback to invoke when searching hotels.
  final Future<HotelSearchResult> Function(HotelSearch search) onListHotels;

  @override
  Future<Map<String, Object?>> invoke(JsonMap args) async {
    final HotelSearch search = HotelSearch.fromJson(args);
    return (await onListHotels(search)).toAiInput();
  }
}
