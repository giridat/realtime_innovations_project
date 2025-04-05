enum AppErrorEnum {
  missingLocalEnvVar(
    'missing_local_env_var',
    devMessage: 'Missing variable in .env file',
  ),
  noInternet('no_internet', devMessage: 'No internet'),
  unsupportedSQLCipherDatabase(
    'unsupported_database',
    devMessage:
        '''This database needs to run with SQLCipher, but that library is not available!''',
  ),
  missingEnvFile('missing_env_file', devMessage: 'Missing .env file'),
  failedToLoadEnvFile(
    'failed_to_load_env_file',
    devMessage: 'Failed to load .env file',
  ),
  verificationTokenNotFound(
    'verification_token_not_found',
    devMessage: 'Verification token not found',
  ),
  noOneTapLoginDataInAppDb(
    'no_one_tap_login_data_in_app_db',
    devMessage: 'No one-tap login data found in the app database',
  ),
  noAuthUserDataInAppDb(
    'no_auth_user_data_in_app_db',
    devMessage: 'No auth user data found in the app database',
  ),
  unauthorized('unauthorized', devMessage: 'Unauthorized access'),
  badRequest('bad_request', devMessage: 'Bad request'),
  notFound('not_found', devMessage: 'Not found'),
  requestTimeout('request timed out', devMessage: 'Request timed out'),
  responseDataError('response_data_error', devMessage: 'Response data error'),
  serverError('server_error', devMessage: 'Server error'),
  badGateway('badGateway', devMessage: 'Bad gateway'),
  serviceUnavailable('serviceUnavailable', devMessage: 'Service unavailable'),
  timedOut('timedOut', devMessage: 'Timed out'),
  unknown('unknown', devMessage: 'Unknown error'),
  unprocessableEntity('unprocessable', devMessage: 'Unprocessable entity'),
  conflict('conflict', devMessage: 'Conflict'),
  ;

  const AppErrorEnum(this.errorCode, {required this.devMessage});
  final String errorCode;
  final String devMessage;
}
