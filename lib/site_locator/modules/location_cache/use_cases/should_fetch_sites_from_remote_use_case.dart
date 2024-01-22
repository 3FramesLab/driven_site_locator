part of location_cache_module;

class ShouldFetchSitesFromRemoteUseCase
    extends BaseFutureUseCase<bool, ShouldFetchSitesFromRemoteParams> {
  @override
  Future<bool> execute(ShouldFetchSitesFromRemoteParams param) async {
    final lastUsedMapRadius = Globals().sharedPreferences.getDouble(
          SiteLocatorStorageKeys.lastUsedMapRadius,
        );

    if (lastUsedMapRadius != param.mapRadius) {
      return true;
    }

    final lastSyncEpoch = Globals().sharedPreferences.getInt(
          SiteLocatorStorageKeys.lastSitesDataSyncDate,
        );

    if (lastSyncEpoch == null) {
      return true;
    }

    final currentDt = DateTimeExtension.now;
    final lastSyncDt = DateTime.fromMillisecondsSinceEpoch(lastSyncEpoch);
    final thresholdDt = DateTime(
      currentDt.year,
      currentDt.month,
      currentDt.day,
      SitesLocationCacheConstants.thresholdHour,
    );

    if (currentDt.difference(lastSyncDt).inHours > 24) {
      return true;
    } else if (currentDt.isAfter(lastSyncDt) &&
        currentDt.isBefore(thresholdDt)) {
      return false;
    } else if (currentDt.isAfter(thresholdDt) &&
        lastSyncDt.isAfter(thresholdDt)) {
      return false;
    } else {
      return true;
    }
  }
}

class ShouldFetchSitesFromRemoteParams {
  final double mapRadius;

  ShouldFetchSitesFromRemoteParams(this.mapRadius);
}
