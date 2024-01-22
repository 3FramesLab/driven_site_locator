part of filter_module;

class SearchCriteriaNotFound extends StatelessWidget {
  const SearchCriteriaNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      EnhancedFilterConstants.searchCriteriaNotFound,
      style: f14RegularBlack,
    );
  }
}
