import 'package:app/models/Cause.dart';
import 'package:flutter/widgets.dart';

class CauseIndicator extends StatelessWidget {
  final ListCause cause;

  const CauseIndicator(this.cause, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            cause.icon,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            cause.title,
            textScaleFactor: .9,
          )
        ],
      ),
    );
  }
}

