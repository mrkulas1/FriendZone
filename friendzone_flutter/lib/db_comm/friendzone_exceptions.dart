/// An exception class representing an error returned by PHP that was caught
/// gracefully, and returned in the "error" field of the JSON response. Will
/// avoid printing 'Exception:' in front of all the error messages in the app
class PHPException implements Exception {
  String message;

  PHPException(this.message);

  @override
  String toString() {
    return message;
  }
}

/// An exception class representing a 401 response from the PHP page, meaning
/// the token is expired or otherwise invalid. This can be caught in the app
/// in order to navigate the user back to the login page on token expiration,
/// so that they can log back in to regenerate a token
class TokenException implements Exception {}
