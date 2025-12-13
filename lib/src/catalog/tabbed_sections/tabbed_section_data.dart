import 'package:flutter/foundation.dart';
import 'package:travel_app/src/catalog/tabbed_sections/tabbed_sections_widget.dart';

class TabSectionData {
  final ValueNotifier<String?> titleNotifier;
  final String childId;

  TabSectionData({required this.titleNotifier, required this.childId});
}

extension type TabbedSectionsData.fromMap(Map<String, Object?> _json) {
  factory TabbedSectionsData({required List<Map<String, Object?>> sections}) =>
      TabbedSectionsData.fromMap({'sections': sections});

  Iterable<TabSectionItemData> get sections => (_json['sections'] as List)
      .cast<Map<String, Object?>>()
      .map<TabSectionItemData>(TabSectionItemData.fromMap);
}
