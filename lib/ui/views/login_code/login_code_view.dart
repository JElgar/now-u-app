import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowu/locator.dart';
import 'package:nowu/router.gr.dart';
import 'package:nowu/services/auth.dart';
import 'package:nowu/services/user_service.dart';
import 'package:nowu/themes.dart';
import 'package:nowu/ui/views/login/components/login_auth_state_listener.dart';
import '../../../generated/l10n.dart';
import 'package:nowu/ui/dialogs/basic/basic_dialog.dart';

import 'bloc/login_code_bloc.dart';
import 'bloc/login_code_state.dart';
import 'model/login_code.dart';

@RoutePage()
class LoginCodeView extends StatelessWidget {
  final String email;
  final String? initialRoute;

  const LoginCodeView({
    Key? key,
    @pathParam required this.email,
    @pathParam this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginAuthStateListener(
      initialRoute: initialRoute,
      child: BlocProvider(
        create: (context) => LoginCodeBloc(
          email: email,
          authenticationService: locator<AuthenticationService>(),
          userService: locator<UserService>(),
        ),
        child: BlocListener<LoginCodeBloc, LoginCodeState>(
          listener: (context, state) {
            switch (state.status) {
              case LoginCodeSubmissionStateFailure():
                showDialog(
                  context: context,
                  builder: (context) {
                    return BasicDialog(
                      BasicDialogArgs(
                        title: 'Login failed',
                        description: S.current.errorAuthenticationFailed,
                      ),
                    );
                  },
                );
                context.read<LoginCodeBloc>().onErrorDialogShown();
                break;

              default:
                // We don't need to do anything for other states
                break;
            }
          },
          child: Theme(
            data: darkTheme,
            child: Builder(
              builder: (context) {
                return Scaffold(
                  // TODO Why do I need to specify this manually?
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: NotificationListener(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: ListView(
                      children: [
                        _LoginForm(email: email),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final String email;

  _LoginForm({required this.email});

  String? getErrorText(LoginCode code) {
    switch (code.displayError) {
      case null:
        return null;
      case LoginCodeValidationErrorEmpty():
        return 'Login code must be provided';
      case LoginCodeValidationErrorInvalid(:final message):
        return message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: SafeArea(
        child: Column(
          //shrinkWrap: true,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        context.router.push(LoginEmailSentRoute(email: email)),
                    label: const Text('Back'),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          // TODO This should be in the default theme
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            Center(
              child: ClipRRect(
                child: Container(
                  width: 65,
                  child: Image.asset('assets/imgs/logo.png'),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
            ),

            const SizedBox(
              height: 35,
            ),
            Text(
              'Type in your 6 digit code from the email to log into now-u',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 35,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your secret 6 digit code',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<LoginCodeBloc, LoginCodeState>(
                  builder: (context, state) {
                    return TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      textCapitalization: TextCapitalization.none,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'e.g. 123456',
                        errorText: getErrorText(state.loginCode),
                      ),
                      onChanged: (value) {
                        context.read<LoginCodeBloc>().updateLoginCode(value);
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: FilledButton(
                    child: const Text('Log in'),
                    onPressed: () {
                      context.read<LoginCodeBloc>().loginWithCode();
                      // TODO Navigate post login!
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            // Uncomment to readd Skip button
            //skipButton(),
          ],
        ),
      ),
    );
  }
}
