part of loading_progress_indicator_module;

class SitesLoadingWalletIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Icon(
        Icons.account_balance_wallet_outlined,
        color: DrivenColors.white,
        size: 40,
      ),
    );
  }
}
