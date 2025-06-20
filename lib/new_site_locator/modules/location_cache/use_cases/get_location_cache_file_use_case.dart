part of location_cache_module;

class GetLocationCacheFileUseCase extends BaseNoParamFutureUseCase<File> {
  @override
  Future<File> execute() async {
    return _locationCacheDirectory;
  }

  Future<File> get _locationCacheDirectory async {
    final path = await _storageLocalPath;
    String fileNameParam = fileName;
    if (MCSitesGovernor.isMCSitesViewEnabled) {
      fileNameParam = mcSitesFileName;
    }
    return File('$path$filePath$fileNameParam');
  }

  Future<String> get _storageLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String get filePath => SitesLocationCacheConstants.locationFilePath;
  String get fileName => SitesLocationCacheConstants.locationFileName;
  String get mcSitesFileName =>
      SitesLocationCacheConstants.mcSiteslocationFileName;
}
