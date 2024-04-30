import 'package:driven_common/driven_components/text_widgets/view_large_title.dart';
import 'package:driven_site_locator/config/site_locator_navigation.dart';
import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_site_locator.dart';

class FuelCardsSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseDrivenScaffold(
      disableBack: true,
      goesInactive: false,
      isInactivityWrapperActivated:
          DrivenSiteLocator.instance.getIsInactivityWrapperActivated(),
      onTimerOut: DrivenSiteLocator.instance.onTimerLogout,
      appBar: DrivenAppBar(
        leading: const DrivenBackButton(),
      ),
      body: Column(
        children: [
          UnderlinedButton.black(
            onPressed: SiteLocatorNavigation.instance.addUnAuthorizeCard,
            text: ViewText.addNewCard,
          ),
          const Center(
            child: ViewLargeTitle(
              title: ViewText.chooseACard,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
