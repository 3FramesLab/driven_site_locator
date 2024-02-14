import 'package:flutter/material.dart';

class FiltersButton extends StatelessWidget {
  const FiltersButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: OutlinedButton(
        onPressed: () {
          // TODO
        },
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(50),
          )),
          foregroundColor: Colors.black,
          side: const BorderSide(width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.filter_alt_outlined),
            Text('Filters'),
          ],
        ),
      ),
    );
  }
}