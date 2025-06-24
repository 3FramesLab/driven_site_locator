// ignore_for_file: must_be_immutable
part of inactivity_module;

class SLInactivityWrapper extends StatelessWidget {
  final SLInactivityController controller = Get.find();

  final Widget? child;
  VoidCallback? sessionExpiryWarningTimerCallback;
  VoidCallback? sessionExpiryTimerCallback;

  SLInactivityWrapper({
    required this.child,
    this.sessionExpiryWarningTimerCallback,
    this.sessionExpiryTimerCallback,
  }) {
    controller.sessionExpiryTimerCallback = sessionExpiryTimerCallback;
    controller.sessionExpiryWarningTimerCallback =
        sessionExpiryWarningTimerCallback;
    controller.initializeTimers();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: controller.handleUserInteraction,
      onPanDown: controller.handleUserInteraction,
      child: child,
    );
  }
}
