import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:travel_app/src/catalog.dart';
import 'package:travel_app/src/screens/travel_planner_screen.dart';

class TravelAppBody extends StatelessWidget {
  final ContentGenerator contentGenerator;
  final String title;

  const TravelAppBody({
    super.key,
    required this.contentGenerator,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, StatefulWidget> tabs = {
      'Travel': TravelPlannerScreen(contentGenerator: contentGenerator),
      'Widget Catalog': const CatalogTab(),
    };
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: const Icon(Icons.menu),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.local_airport),
              const SizedBox(width: 16.0),
              Text(title),
            ],
          ),
          actions: [
            const Icon(Icons.person_outline),
            const SizedBox(width: 8.0),
          ],
          bottom: TabBar(
            tabs: tabs.entries.map((entry) => Tab(text: entry.key)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.entries.map((entry) => entry.value).toList(),
        ),
      ),
    );
  }
}

class CatalogTab extends StatefulWidget {
  const CatalogTab({super.key});

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DebugCatalogView(catalog: travelAppCatalog);
  }

  @override
  bool get wantKeepAlive => true;
}
