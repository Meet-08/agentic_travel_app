import 'package:genui/genui.dart';
import 'package:travel_app/src/catalog/checkbox_filter_chips/checkbox_filter_chips.schema.dart';
import 'package:travel_app/src/catalog/date_input/date_input.schema.dart';
import 'package:travel_app/src/catalog/information_card/information_card.schema.dart';
import 'package:travel_app/src/catalog/input_group/input_group.schema.dart';
import 'package:travel_app/src/catalog/itinerary/itinerary.schema.dart';
import 'package:travel_app/src/catalog/listings_booker/listings_booker.dart';
import 'package:travel_app/src/catalog/option_filter_chip/option_filter_chip.schema.dart';
import 'package:travel_app/src/catalog/tabbed_sections/tabbed_sections.schema.dart';
import 'package:travel_app/src/catalog/text_input_chip/text_input_chip.schema.dart';
import 'package:travel_app/src/catalog/trailhead/trailhead.schema.dart';
import 'package:travel_app/src/catalog/travel_carousel/travel_carousel.dart';

final Catalog travelAppCatalog = Catalog([
  CoreCatalogItems.button,
  CoreCatalogItems.column,
  CoreCatalogItems.text,
  CoreCatalogItems.image,
  checkboxFilterChipsInput,
  dateInputChip,
  informationCard,
  inputGroup,
  itinerary,
  listingsBooker,
  optionFilterChipInput,
  tabbedSections,
  textInputChip,
  trailhead,
  travelCarousel,
]);
