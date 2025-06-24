part of map_view_module;

class SLGetSiteSourceFromCardTypeUseCase extends BaseUseCase<String, String> {
  @override
  String execute(String param) {
    try {
      final cardType = param;

      final siteSourceMapping = UmaSLProperties.siteSourceMapping;

      if (cardType.isEmpty) {
        return siteSourceMapping.entries.firstWhere((e) => e.value.isEmpty).key;
      } else {
        return siteSourceMapping.entries
            .firstWhere((e) => e.value.containsIgnoreCase(cardType))
            .key;
      }
    } catch (_) {
      return UmaSLProperties.defaultSiteSource;
    }
  }
}
