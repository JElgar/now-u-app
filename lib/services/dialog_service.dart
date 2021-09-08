import 'dart:async';
import 'package:app/assets/components/buttons/darkButton.dart';

class AlertRequest {
  final String title;
  final String description;
  final String headerImage;
  final List buttons;

  AlertRequest({this.title, this.description, this.headerImage, this.buttons});
}

class AlertResponse {
  final dynamic response;
  AlertResponse({this.response});
}

class CustomDialogButton {
  String text;
  dynamic response; // If the button is clicked what should the dialog service return
  DarkButtonStyle style;
  //Function onClick; // This might be handy in the future
  bool closeOnClick;

  // Constructor:
  CustomDialogButton({
    this.text,
    this.response,
    this.style,
    this.closeOnClick,
    //this.onClick,
  });
}

class DialogService {
  Function(AlertRequest) _showDialogListener;
  Completer<AlertResponse> _dialogCompleter;

  void registerDialogListener(Function(AlertRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  Future showDialog({
    String title,
    String description,
    String headerImage,
    List buttons,
  }) {
    _dialogCompleter = Completer<AlertResponse>();
    _showDialogListener(
        AlertRequest(title: title, description: description, headerImage: headerImage, buttons: buttons));
    return _dialogCompleter.future;
  }

  void dialogComplete(AlertResponse response) {
    if (_dialogCompleter != null) {
      _dialogCompleter.complete(response);
    }
    _dialogCompleter = null;
  }
}
