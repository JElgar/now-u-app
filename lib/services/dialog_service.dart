import 'dart:async';
import 'package:nowu/assets/components/buttons/darkButton.dart';
import 'package:nowu/managers/dialog_manager.dart';
export 'package:nowu/managers/dialog_manager.dart';

class AlertResponse {
  final dynamic response;
  AlertResponse({this.response});
}

class DialogButton {
  String text;
  dynamic
      response; // If the button is clicked what should the dialog service return
  DarkButtonStyle? style;

  DialogButton({
    required this.text,
    this.response,
    this.style,
  });
}

class DialogService {
  late Function(CustomDialog) _showDialogListener;
  Completer<AlertResponse>? _dialogCompleter;

  void registerDialogListener(Function(CustomDialog) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  Future showDialog(CustomDialog dialog) {
    _dialogCompleter = Completer<AlertResponse>();
    _showDialogListener(dialog);
    return _dialogCompleter!.future;
  }

  void dialogComplete(AlertResponse response) {
    if (_dialogCompleter != null) {
      _dialogCompleter!.complete(response);
    }
    _dialogCompleter = null;
  }
}
