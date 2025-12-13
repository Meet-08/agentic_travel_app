import 'package:flutter/material.dart';
import 'package:travel_app/src/catalog/tabbed_sections/tabbed_section_data.dart';

class TabbedSectionsWidget extends StatefulWidget {
  final List<TabSectionData> sections;
  final Widget Function(String id) buildChild;

  const TabbedSectionsWidget({
    super.key,
    required this.sections,
    required this.buildChild,
  });

  @override
  State<TabbedSectionsWidget> createState() => _TabbedSectionsWidgetState();
}

class _TabbedSectionsWidgetState extends State<TabbedSectionsWidget>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.sections.length, vsync: this);
    _tabController.addListener(
      () => setState(() => _selectedIndex = _tabController.index),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.sections
              .map(
                (section) => Tab(
                  child: ValueListenableBuilder(
                    valueListenable: section.titleNotifier,
                    builder: (context, value, _) => Text(value ?? ""),
                  ),
                ),
              )
              .toList(),
        ),

        IndexedStack(
          index: _selectedIndex,
          children: widget.sections
              .map((section) => widget.buildChild(section.childId))
              .toList(),
        ),
      ],
    );
  }
}

extension type TabSectionItemData.fromMap(Map<String, Object?> _json) {
  factory TabSectionItemData({
    required Map<String, Object?> title,
    required String child,
  }) => TabSectionItemData.fromMap({'child': child, 'title': title});

  Map<String, Object?> get title => _json['title'] as Map<String, Object?>;
  String get childId => _json['child'] as String;
}
