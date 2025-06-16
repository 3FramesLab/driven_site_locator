// part of sl_filter_module;

// class BrandQuickFilterPage extends StatelessWidget {
//   BrandQuickFilterPage({super.key});

//   final AuthSLTypeChoicesController authSLTypeChoicesController = Get.find();
//   final SiteLocatorController siteLocatorController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         DrivenScaffold(
//           appBar: _appBar(),
//           body: Container(
//             color: DrivenColors.white,
//             child: _body(),
//           ),
//         ),
//         Obx(
//           () => SlLoader(
//             showLoader: siteLocatorController.firstTimeLoading(),
//           ),
//         ),
//       ],
//     );
//   }

//   DrivenAppBar _appBar() => DrivenAppBar(
//         showBackButton: true,
//         onBackPressed: authSLTypeChoicesController.backToMapPage,
//         toolBarHeight: _displayRepresentativePricing ? 134 : 80,
//         title: Align(
//           alignment: _appBarTitleAlignment,
//           child: SLHeader(
//             padding: const EdgeInsets.only(right: 6),
//             fleetChangeCallback: _fleetChangeCallback,
//           ),
//         ),
//         actions: [if (DcSiteLocatorUtils.isGuest) AddCard()],
//         preferredSizeWidget: const PreferredSize(
//           preferredSize: Size(double.infinity, kToolbarHeight),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: ViewLargeTitle(
//               title: SLViewText.selectBrands,
//               padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//             ),
//           ),
//         ),
//       );

//   Future<void> _fleetChangeCallback() async {
//     Get.back();
//     siteLocatorController.recentViewSiteLocations.clear();
//     await DcSiteLocatorUtils.callMerchSitesOnFilterChange();
//   }

//   Widget _body() {
//     return Column(
//       children: [
//         _searchContent(),
//         BrandQuickFilterList(),
//         BrandQuickFilterBottomContent(),
//       ],
//     );
//   }

//   Widget _searchContent() {
//     return Container(
//       color: DrivenColors.pageBackgroundColor,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
//         child: TapRegion(
//           onTapOutside: (event) => FocusScope.of(Globals.context).unfocus(),
//           child: const SearchBrandTextField(),
//         ),
//       ),
//     );
//   }

//   AlignmentGeometry get _appBarTitleAlignment {
//     return _displayRepresentativePricing
//         ? Alignment.centerLeft
//         : Alignment.centerRight;
//   }

//   bool get _displayRepresentativePricing =>
//       DcSiteLocatorUtils.isGuest &&
//       DcSiteLocatorUtils.displayRepresentativePricing();
// }
