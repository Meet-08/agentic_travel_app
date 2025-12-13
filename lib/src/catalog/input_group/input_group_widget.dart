import 'package:genui/genui.dart';

extension type InputGroupData.fromMap(Map<String, Object?> _json) {
  factory InputGroupData({
    required JsonMap submitLabel,
    required List<String> children,
    required JsonMap action,
  }) => InputGroupData.fromMap({
    'submitLabel': submitLabel,
    'children': children,
    'action': action,
  });

  JsonMap get submitLabel => _json['submitLabel'] as JsonMap;
  List<String> get children => (_json['children'] as List).cast<String>();
  JsonMap get action => _json['action'] as JsonMap;
}
