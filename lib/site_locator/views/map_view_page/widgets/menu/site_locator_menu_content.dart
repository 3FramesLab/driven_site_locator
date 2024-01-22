import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/views/map_view_page/widgets/menu/site_locator_menu.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/widgets/a_panel_handle.dart';

class SiteLocatorMenuContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        PanelHandle(),
        const SiteLocatorMenu(),
      ],
    );
  }
}
