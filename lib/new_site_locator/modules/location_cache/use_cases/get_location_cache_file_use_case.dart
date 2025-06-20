part of location_cache_module;

class GetLocationCacheFileUseCase extends BaseNoParamFutureUseCase<File> {
  @override
  Future<File> execute() async {
    return _locationCacheDirectory;
  }

  Future<File> get _locationCacheDirectory async {
    final path = await _storageLocalPath;
    final fileNameParam = fileName;
    return File('$path$filePath$fileNameParam');
  }

  Future<String> get _storageLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String get filePath => SLInternalText.locationFilePath;
  String get fileName => SLInternalText.locationFileName;
}
