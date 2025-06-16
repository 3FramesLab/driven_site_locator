part of sl_filter_module;

class SearchBrandTextField extends StatefulWidget {
  const SearchBrandTextField({super.key});

  @override
  State<SearchBrandTextField> createState() => _SearchBrandTextField();
}

class _SearchBrandTextField extends State<SearchBrandTextField> {
  final AuthSLTypeChoicesController authSLTypeChoicesController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (onFocus) {},
      child: _searchTextField(),
    );
  }

  Widget _searchTextField() => CustomCardWithShadow(
        hasShadow: false,
        child: TextField(
          textInputAction: TextInputAction.search,
          controller: authSLTypeChoicesController.searchBrandEditingController,
          onChanged: onChanged,
          onSubmitted: (_) => searchTextfieldIconTapped(forceSearch: true),
          cursorColor: DrivenColors.black38,
          cursorWidth: 1.2,
          decoration: _searchTextFieldDecoration().copyWith(
            hintText: SLViewText.searchFor,
          ),
        ),
      );

  InputDecoration _searchTextFieldDecoration() =>
      SiteLocatorTextFieldStyle().searchTextFieldDecoration(
          suffixIcon: _searchTextFieldSuffixIcon(), borderWidth: 0.1);

  Widget _searchTextFieldSuffixIcon() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 3, 3),
        child: Semantics(
          container: true,
          label: SLSemanticStrings.searchBrand,
          child: GestureDetector(
            onTap: searchTextfieldIconTapped,
            child: _searchTextFieldIconContainer(),
          ),
        ),
      );

  Widget _searchTextFieldIconContainer() =>
      SiteLocatorTextFieldStyle().searchTextFieldIconContainer(
        child: _searchTextfieldIcon(),
        color: DrivenColors.primary,
      );

  Widget _searchTextfieldIcon() => const Icon(
        Icons.search,
        size: 24,
        color: DrivenColors.white,
      );

  void onChanged(String input) {
    final query = input.toLowerCase().trim();
    authSLTypeChoicesController.searchedBrandText(query);

    authSLTypeChoicesController.filteredBrandSiteFilterList.assignAll(
        authSLTypeChoicesController.brandSiteFilterList
            .where((e) => e.label.toLowerCase().contains(query))
            .toList());

    authSLTypeChoicesController.filteredBrandSiteFilterList.refresh();
  }

  Future<void> searchTextfieldIconTapped({bool forceSearch = false}) async {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
