import 'package:app/locator.dart';
import 'package:app/services/auth.dart';

class ApiService {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  String domainPrefix = "https://api.now-u.com/api/v1/";
}
