import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';
import 'package:hive/hive.dart';

part 'structured_formatting.g.dart';

@HiveType(typeId: SLInternalText.structuredFormattingTypeId)
class StructuredFormatting extends HiveObject {
  @HiveField(0)
  String? mainText;

  @HiveField(1)
  String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  StructuredFormatting.fromJson(Map<String, dynamic> json) {
    mainText = json['main_text'];
    secondaryText = json['secondary_text'];
  }

  @override
  String toString() {
    return '${mainText ?? ''}, ${secondaryText ?? ''}';
  }
}
