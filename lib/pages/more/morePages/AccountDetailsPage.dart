import 'package:app/assets/StyleFrom.dart';
import 'package:app/assets/components/buttons/darkButton.dart';
import 'package:app/assets/components/inputs.dart';
import 'package:app/pages/more/morePages/ConfirmationModal.dart';
import 'package:flutter/material.dart';
import 'package:app/assets/components/customAppBar.dart';
import 'package:app/viewmodels/account_details_model.dart';
import 'package:app/assets/components/textButton.dart';

// TODO move models into models
import 'package:app/services/google_location_search_service.dart';

import 'package:stacked/stacked.dart';

class AccountDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(
        text: "Edit account details",
        context: context,
        backButtonText: "Menu",
      ),
      body: ViewModelBuilder<AccountDetailsViewModel>.reactive(
        viewModelBuilder: () => AccountDetailsViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) {
          return Form(
              key: model.formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: ListView(
                  children: <Widget>[
                    // TODO: Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 8),
                      child: Text(
                        "Name",
                        style: textStyleFrom(
                          Theme.of(context).primaryTextTheme.headline5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                        autofocus: false,
                        initialValue: model.currentUser.getName(),
                        style: CustomFormFieldStyle.Light,
                        onChanged: (String name) {
                          model.name = name;
                        }),
                    // TODO: Age
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 28.5, 0, 8),
                      child: Text(
                        "Date of birth",
                        style: textStyleFrom(
                          Theme.of(context).primaryTextTheme.headline5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () => _datePicker(context, model.latestDob,
                                (DateTime date) {
                              model.dob = date;
                            }),
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            style: CustomFormFieldStyle.Light,
                            controller: model.dobFieldController,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 28.5, 0, 8),
                      child: Text(
                        "Location",
                        style: textStyleFrom(
                          Theme.of(context).primaryTextTheme.headline5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          // generate a new token here
                          final Suggestion result = await showSearch(
                            context: context,
                            delegate: AddressSearch(model.fetchSuggestions),
                          );

                          print("result");
                          print(result);
                          // This will change the text displayed in the TextField
                          if (result != null) {
                            final placeDetails =
                                await model.getPlaceDetails(result.placeId);
                            print("We go em ${placeDetails.zipCode}");
                          }
                        },
                        child: AbsorbPointer(
                          child: CustomTextFormField(
                            style: CustomFormFieldStyle.Light,
                            controller: model.locationFieldController,
                          ),
                        )),
                    // TODO: Email
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 28.5, 0, 8),
                      child: Text(
                        "Email",
                        style: textStyleFrom(
                          Theme.of(context).primaryTextTheme.headline5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // TODO: Make field disabled
                    CustomTextFormField(
                      autofocus: false,
                      style: CustomFormFieldStyle.Light,
                      initialValue: model.currentUser.getEmail(),
                      enabled: false,
                    ),
                    // TODO: Receive newsletter toggle
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child: Text(
                            "Receive newsletter",
                            style: textStyleFrom(
                              Theme.of(context).primaryTextTheme.headline4,
                            ),
                          ),
                        ),
                        // TODO: Implement Toggle Button
                        // CustomToggleButton(),
                      ],
                    ),
                    // TODO: Organisation Code
                    // TODO: CustomSwitch in inputs.dart
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                      child: Text(
                        "Organisation",
                        style: textStyleFrom(
                          Theme.of(context).primaryTextTheme.headline4,
                        ),
                      ),
                    ),
                    Column(
                        children: model.userOrganisation != null
                            ? [
                                Row(
                                  children: [
                                    Image.network(
                                      model.userOrganisation.getLogoLink(),
                                      width: 60,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        model.userOrganisation.getName(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Theme.of(context).errorColor,
                                      ),
                                      onPressed: () {
                                        model.leaveOrganisation();
                                      },
                                    )
                                  ],
                                )
                              ]
                            : [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 21),
                                  child: Text(
                                    "If you work for one of our business partners, you can enter the organisation code below so they can see the actions you’ve taken.",
                                    style: textStyleFrom(
                                      Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText2,
                                    ),
                                  ),
                                ),
                                CustomTextFormField(
                                    autofocus: false,
                                    hintText: 'Enter organisation code',
                                    style: CustomFormFieldStyle.Light,
                                    onChanged: (String code) {
                                      model.orgCode = code;
                                    }),
                              ]),
                    // TODO: Ok button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 21, 0, 0),
                      child: DarkButton(
                        "Save",
                        onPressed: model.save,
                      ),
                    ),
                    // TODO: Delete account button
                    SizedBox(
                      height: 82,
                    ),
                    //TODO add this in
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(),
                        ),
                        CustomTextButton(
                          "Delete my account",
                          onClick: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  // This off sets content from keyboard if visible
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: ConfirmationModal(),
                                ),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    // TODO: Save Changes
                  ],
                ),
              ));
        },
      ),
    );
  }

  Future<Null> _datePicker(
      BuildContext context, DateTime date, Function onChanged) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime(1995, 1),
      firstDate: DateTime(1800, 1),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Colors.green,
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
            //buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != date) {
      onChanged(picked);
    }
  }
}

class AddressSearch extends SearchDelegate<Suggestion> {
  Function fetchSuggestions;
  AddressSearch(this.fetchSuggestions);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : fetchSuggestions(
              query, Localizations.localeOf(context).languageCode),
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: EdgeInsets.all(16.0),
              child: Text('Enter your address'),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title:
                        Text((snapshot.data[index] as Suggestion).description),
                    onTap: () {
                      close(context, snapshot.data[index] as Suggestion);
                    },
                  ),
                  itemCount: snapshot.data.length,
                )
              : Container(child: Text('Loading...')),
    );
  }

  @override
  void showResults(BuildContext context) {}
}
