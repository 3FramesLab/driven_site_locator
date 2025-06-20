part of location_cache_module;

class WriteSitesInLocationCacheUseCase
    extends BaseFutureUseCase<bool, WriteSitesInLocationCacheParams> {
  @override
  Future<bool> execute(WriteSitesInLocationCacheParams param) async {
    final file = param.locationCacheFile;
    final dir = Directory(file.parent.path);
    if (!dir.existsSync()) {
      await dir.create();
    }

    if (!file.existsSync()) {
      await file.create();
    }
    String jsonString = '[]';
    if (param.sites.isNotEmpty) {
      jsonString = jsonEncode(param.sites.map((e) => e.toJson()).toList());
    }

    await file.writeAsString(jsonString);
    if (param.sites.isNotEmpty) {
      await Globals().sharedPreferences.setInt(
            SLInternalText.lastSitesDataSyncDate,
            DateTimeExtension.now.millisecondsSinceEpoch,
          );
      await Globals().sharedPreferences.setString(
            SLInternalText.lastUserCenterLoc,
            MapUtilities.appendLatLng(param.centerLocation),
          );
      await Globals().sharedPreferences.setDouble(
            SLInternalText.lastUsedMapRadius,
            param.mapRadius,
          );
    }
    return true;
  }
}

class WriteSitesInLocationCacheParams {
  final List<SiteLocation> sites;
  final File locationCacheFile;
  final LatLng centerLocation;
  final double mapRadius;

  const WriteSitesInLocationCacheParams({
    required this.sites,
    required this.locationCacheFile,
    required this.centerLocation,
    required this.mapRadius,
  });
}
