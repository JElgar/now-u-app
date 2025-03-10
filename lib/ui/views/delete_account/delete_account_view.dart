import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import '../../../services/auth.dart';
import '../../../services/user_service.dart';
import 'delete_account_bloc.dart';
import 'delete_account_state.dart';

@RoutePage()
class DeleteAccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeleteAccountBloc bloc = DeleteAccountBloc(
      authenticationService: locator<AuthenticationService>(),
      appRouter: AutoRouter.of(context),
      userService: locator<UserService>(),
    );

    return BlocProvider<DeleteAccountBloc>(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Account'),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        const TextSpan(
                          text:
                              'Are you sure you want to delete your account? ',
                        ),
                        const TextSpan(
                          text: 'This action cannot be undone.',
                          style: TextStyle(fontFamily: 'PPPangramsSemibold'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To confirm, please type "$deleteUserConfirmationText" below.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: bloc.updateInputName,
                    decoration: const InputDecoration(
                      hintText: deleteUserConfirmationText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DeleteAccountButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isNameValid
              ? context.read<DeleteAccountBloc>().deleteAccount
              : null,
          child: const Text('Delete Account'),
        );
      },
    );
  }
}
