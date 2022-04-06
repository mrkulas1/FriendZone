import 'package:friendzone_flutter/models/current_user.dart';

/// Enum holding possible results from a login operation
enum AuthStatus { valid, noUser, badCredentials, lockedOut, internalError }

/// Class representing the result of a login operation. Contains a [status]
/// and a [_user]. The [_user] is null if the login failed. [status] will
/// indicate success, or the failure reason.
class AuthResult {
  AuthStatus status;
  CurrentUser? _user;
  String token;

  /// Construct an [AuthResult] with a [status] and null [_user]
  AuthResult({required this.status, required this.token}) {
    _user = null;
  }

  /// Add the user [user] to the [AuthResult]
  void setUser(CurrentUser user) {
    _user = user;
    _user!.setToken(token);
  }

  /// Return the [_user], if it is not null. Will throw an exception if
  /// the login failed ([_user] is null).
  CurrentUser getUser() {
    return _user!;
  }

  /// Check if the login operation succeeded. Only returns true if
  /// [status] is [AuthStatus.valid]
  bool success() {
    return status == AuthStatus.valid;
  }

  /// Return a message corresponding to the [status] of this [AuthResult]
  String getStatusMessage() {
    switch (status) {
      case AuthStatus.valid:
        return "Login successful";
      case AuthStatus.noUser:
        return "No user exists for the provided email address";
      case AuthStatus.badCredentials:
        return "Invalid email/password combination";
      case AuthStatus.lockedOut:
        return "Your account is locked out due to too many failed login "
            "attempts. Contact an administrator to unlock your account";
      case AuthStatus.internalError:
        return "An internal error occured. Check your internet connection "
            "and try again.";
    }
  }
}
