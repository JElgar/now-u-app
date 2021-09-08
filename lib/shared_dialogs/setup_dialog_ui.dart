import 'package:app/services/dialog_service.dart';
import 'package:app/enums/dialog_type.dart';
import 'package:flutter/material.dart';
import 'package:app/locator.dart';

void setupDialogUi(){
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.basic: (BuildContext context, AlertRequest request, Function(AlertRequest) completer) => BasicDialog(request: request, completer: completer),
  }

  dialogService.registerCustomDialogBuilders(builders);

}