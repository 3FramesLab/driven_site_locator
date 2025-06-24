part of map_view_module;

class SLAdjustDuplicateLatLngUseCase
    extends BaseUseCase<void, List<SiteLocation>?> {
  @override
  void execute(List<SiteLocation>? param) {
    final siteLocations = param;
    if (siteLocations != null && siteLocations.isNotEmpty) {
      // Group by (latitude, longitude)
      final Map<String, List<SiteLocation>> grouped = {};
      for (final site in siteLocations) {
        if (site.siteLatitude != null && site.siteLongitude != null) {
          final key = '${site.siteLatitude},${site.siteLongitude}';
          grouped.putIfAbsent(key, () => []).add(site);
        }
      }
      // For each group with duplicates, increment latitude to make unique
      for (final group in grouped.values) {
        if (group.length > 1) {
          for (int i = 1; i < group.length; i++) {
            // Get the current latitude, default to 0 if null
            final lat = group[i].siteLatitude ?? 0.0;
            // Convert to string with enough precision
            final latStr = lat.toStringAsFixed(7);
            // Split at the decimal point
            final parts = latStr.split('.');
            // If decimal part is long enough, increment last 4 digits
            if (parts.length == 2 && parts[1].length >= 4) {
              final before = parts[1].substring(0, parts[1].length - 4);
              final last4 = parts[1].substring(parts[1].length - 4);
              int last4int = int.parse(last4);
              last4int += i;
              // Ensure last4 stays 4 digits with leading zeros
              String newLast4 = last4int.toString().padLeft(4, '0');
              // If overflow, keep only last 4 digits
              if (newLast4.length > 4) {
                newLast4 = newLast4.substring(newLast4.length - 4);
              }
              final String newDecimal = before + newLast4;
              final String newLatStr = '${parts[0]}.$newDecimal';
              group[i].siteLatitude = double.parse(newLatStr);
            } else {
              // Fallback: just add i * 0.0001
              group[i].siteLatitude = lat + i * 0.0001;
            }
          }
        }
      }
    }
  }
}
