import 'package:flutter/material.dart';
import 'package:app/assets/components/buttons/darkButton.dart';
import 'package:app/viewmodels/account_details_model.dart';
import 'package:stacked/stacked.dart';

class ConfirmationModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountDetailsViewModel>.reactive(
        viewModelBuilder: () => AccountDetailsViewModel(),
        builder: (context, model, child) {
          return Container(
            color: Color(0xff757575),
            height: 250.0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'You are about to permanently delete your account. Are you sure?',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  DarkButton(
                    "Yes, delete",
                    onPressed: () {
                      model.delete();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
