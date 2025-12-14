import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:logging/logging.dart';
import 'package:travel_app/firebase_options.dart';
import 'package:travel_app/src/catalog.dart';
import 'package:travel_app/src/constants.dart';
import 'package:travel_app/src/screens/travel_app_body.dart';
import 'package:travel_app/src/screens/travel_planner_screen.dart';
import 'package:travel_app/src/services/booking_service.dart';
import 'package:travel_app/src/services/list_hotels_service.dart';

const _title = 'Agentic Travel Inc';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await loadImagesJson();
  configureGenUiLogging(level: Level.ALL);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ContentGenerator contentGenerator = FirebaseAiContentGenerator(
    catalog: travelAppCatalog,
    systemInstruction: prompt,
    additionalTools: [
      ListHotelsService(onListHotels: BookingService.instance.listHotels),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: TravelAppBody(contentGenerator: contentGenerator, title: _title),
    );
  }
}
