import 'package:driven_site_locator/driven_components/driven_components.dart';

class BackButtonWithTitle extends StatelessWidget {
  final String? title;
  final void Function()? onBackButtonPressed;

  const BackButtonWithTitle({this.title, this.onBackButtonPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(45)),
      ),
      padding: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _body(),
      ),
    );
  }

  Widget _body() => GestureDetector(
        onTap: onBackButtonPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios_outlined,
                size: 24,
                color: Colors.black,
              ),
              const SizedBox(width: 20),
              Text(
                title ?? '',
                style: f24ExtraboldBlackDark,
              ),
            ],
          ),
        ),
      );
}
