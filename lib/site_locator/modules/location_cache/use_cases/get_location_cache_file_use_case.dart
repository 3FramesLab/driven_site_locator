part of location_cache_module;

class GetLocationCacheFileUseCase extends BaseNoParamFutureUseCase<File> {
  @override
  Future<File> execute() async {
    return _locationCacheDirectory;
  }

  Future<File> get _locationCacheDirectory async {
    final path = await _storageLocalPath;
    return File('$path$filePath$fileName');
  }

  Future<String> get _storageLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String get filePath => SitesLocationCacheConstants.locationFilePath;
  String get fileName => SitesLocationCacheConstants.locationFileName;
}
