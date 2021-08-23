import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/assets/components/buttons/customIconButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/models/Cause.dart';

class CauseTile extends StatelessWidget {
  final Cause cause;
  final bool isSelected;
  final IconData causeIcon;
  final VoidCallback gestureFunction;
  // final VoidCallback getInfoFunction;

  CauseTile(
      {@required this.cause,
      @required this.isSelected,
      @required this.gestureFunction,
      // @required this.getInfoFunction,
      @required this.causeIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gestureFunction,
      child: Container(
          decoration: BoxDecoration(
              color: isSelected ? Color(0XFFFFF3E5) : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: isSelected
                  ? Border.all(width: 3, color: Color(0XFFFF8800))
                  : Border.all(width: 3, color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    offset: Offset(0, 8),
                    blurRadius: 6)
              ]),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                      child: Icon(causeIcon,
                          size: 45.0,
                          color: isSelected
                              ? Color(0XFFFF8800)
                              : Color(0XFF373A4A)),
                    ),
                    Text(
                      '${cause.name}',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text('Learn more', textAlign: TextAlign.center)),
                    Expanded(
                        flex: 1,
                        child: CustomIconButton(
                            size: ButtonSize.Small,
                            isCircularButton: true,
                            onPressed: () {
                              print('hello');
                            },
                            icon: FontAwesomeIcons.question))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
