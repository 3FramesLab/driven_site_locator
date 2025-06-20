part of map_view_module;

class GetAccessTokenForSitesUseCase extends BaseNoParamFutureUseCase<String> {
  @override
  Future<String> execute() async {
    String? siteLocatorAccessToken;
    if (isAccessTokenExpired) {
      final SiteLocatorAccessTokenController siteLocatorAccessTokenController =
          Get.put(SiteLocatorAccessTokenController());
      siteLocatorAccessToken =
          await siteLocatorAccessTokenController.getAccessToken();
    } else {
      siteLocatorAccessToken = Globals().sharedPreferences.getString(
            SLInternalText.siteLocatorAccessToken,
          );
    }
    return siteLocatorAccessToken ?? '';
  }

  bool get isAccessTokenExpired {
    bool isTokenExpired = true;
    final lastUpdatedTime = Globals().sharedPreferences.getString(
          SLInternalText.siteLocatorAccessTokenLastUpdatedTime,
        );
    if (lastUpdatedTime != null) {
      final lastUpdatedTimeInDateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(lastUpdatedTime));
      final timeDiffInMinutes =
          DateTime.now().difference(lastUpdatedTimeInDateTime).inMinutes;
      if (timeDiffInMinutes <
          SLInternalText.siteLocatorAccessTokenExpiryTimeInMinutes) {
        isTokenExpired = false;
      }
    }
    return isTokenExpired;
  }
}
