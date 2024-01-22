import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/controllers/setup_wizard_controller.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:get/get.dart';

class PersonalizedPreferenceCheckbox extends StatelessWidget {
  final SiteFilter filter;
  final SetUpWizardController setUpWizardController = Get.find();

  PersonalizedPreferenceCheckbox({
    required this.filter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: DrivenCheckbox(
            textWidget: Text(
              filter.label,
              style: f14RegularBlack,
            ),
            value:
                setUpWizardController.selectedPreferences.contains(filter.key),
            onChanged: (value) => onCheckboxChanged(isChecked: value),
            onTap: () => onCheckboxTitleClick(filter.key),
          ),
        ));
  }

  void onCheckboxChanged({bool? isChecked}) {
    final bool checkedFlag = isChecked ?? false;
    setUpWizardController.onPreferenceCheckChange(
      siteFilter: filter,
      isChecked: checkedFlag,
    );
  }

  void onCheckboxTitleClick(String key) {
    final value = setUpWizardController.selectedPreferences.contains(key);
    onCheckboxChanged(isChecked: !value);
  }
}
