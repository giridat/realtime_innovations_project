enum PlatformErrorEnum {
  /// Occurs when the user cancels the action, typically during OAuth or
  /// other permission request flows.
  requestCanceled('CANCELED', devMessage: 'Platform Request canceled'),

  /// Represents any unknown or unexpected errors that may occur.
  unknownError('UNKNOWN', devMessage: 'Unknown Platform error'),

  /// When the app does not have the necessary permissions to perform an action.
  permissionDenied('PERMISSION_DENIED', devMessage: 'Permission denied'),

  /// If no camera is available on the device, this error is thrown.
  cameraNotAvailable(
    'CAMERA_NOT_AVAILABLE',
    devMessage: 'Camera not available',
  ),

  /// Thrown when the ImagePicker plugin is already in use and
  /// a new request cannot be processed.
  pluginAlreadyInUse(
    'PLUGIN_ALREADY_IN_USE',
    devMessage: 'Plugin already in use',
  ),

  /// On iOS, if the system is unable to create a temporary file
  /// for image processing.
  temporaryFileCreationFailed(
    'TEMPORARY_FILE_CREATION_FAILED',
    devMessage: 'Temporary file creation failed',
  ),

  /// On Android, if the system fails to allocate an activity for the plugin.
  activityAllocationFailed(
    'ACTIVITY_ALLOCATION_FAILED',
    devMessage: 'Activity allocation failed',
  ),

  /// When the user exits the image picking process without selecting a file.
  fileNotSelected('FILE_NOT_SELECTED', devMessage: 'No file selected');

  const PlatformErrorEnum(this.errorCode, {required this.devMessage});
  final String errorCode;
  final String devMessage;

  static PlatformErrorEnum getErrorFromCode(String? code) {
    return PlatformErrorEnum.values.firstWhere(
      (error) => error.errorCode == code,
      orElse: () => PlatformErrorEnum.unknownError,
    );
  }
}
