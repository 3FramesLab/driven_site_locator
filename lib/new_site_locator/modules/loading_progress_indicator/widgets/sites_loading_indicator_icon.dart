part of loading_progress_indicator_module;

class SitesLoadingIndicatorIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const imagePath = SitesLoadingProgressProps.fuelPumpIconPath;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Image.asset(imagePath),
    );
  }
}
