import 'dart:core';

import 'package:flutter/services.dart';

const _assetImageCatalogPath = 'assets/travel_images';

const _assetImageCatalogJsonFile = '$_assetImageCatalogPath/_images.json';
Future<String> assetsImageCatalogJson() async {
  String result = await rootBundle.loadString(_assetImageCatalogJsonFile);
  return result.replaceAll(
    '"image_file_name": "',
    '"image_file_name": "$_assetImageCatalogPath/',
  );
}
