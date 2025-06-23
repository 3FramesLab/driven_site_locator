part of select_your_card_module;

class SelectYourCardPage extends StatelessWidget {
  SelectYourCardPage({super.key});
  final SelectYourCardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    _init();
    return DrivenScaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initCardType();
    });
  }

  DrivenAppBar _appBar() {
    return DrivenAppBar(
      showBackButton: true,
      centerTitle: false,
      toolBarHeight: 80,
      preferredSizeWidget: const PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ViewLargeTitle(
            title: SLViewText.selectYourCard,
            padding: EdgeInsets.only(left: 4),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        const SizedBox(height: 8),
        _screenDescArea(),
        const SizedBox(height: 16),
        _cardsListArea(),
        _continueToMapButtonArea(),
      ],
    );
  }

  Container _screenDescArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: DrivenColors.pageBackgroundColor,
      child: const Text(
        SLViewText.selectYourCardDesc,
        style: f16RegularBlack,
      ),
    );
  }

  Widget _cardsListArea() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: DrivenColors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: CardTypeList(),
      ),
    );
  }

  Widget _continueToMapButtonArea() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15,
            offset: Offset(0, 0.75),
          )
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 26, bottom: 40),
      alignment: Alignment.center,
      child: ContinueToMapButton(),
    );
  }
}
