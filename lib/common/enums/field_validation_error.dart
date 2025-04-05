enum NumberInputError {
  nullValue,
  zeroNotAllowed,
  outOfRange,
  cannotGreaterThan,
  cannotLessThan,
  decimalNotAllowed,
  negativeNotAllowed,
  invalid,
  errorAfterRequestFailure,
}

enum TextInputError {
  nullValue,
  empty,
  tooShort,
  invalid,
  tooLong,
  errorPostServerRequest,

  // Allow letters and whitespace only (e.g., for names)
  invalidName,
  // Allow letters, numbers, whitespace, commas, periods, question
  invalidMultiLineText,
  // Allow letters only, no spaces or special characters
  invalidOnlyLetters,
  // Allow letters and numbers only
  invalidOnlyLettersAndNumbers,
  // only letter number and space
  invalidOnlyLettersAndNumbersAndSpace,
  invalidOnlyLettersAndSpace,
  serverErrorMessage,
  invalidEnglishSentence,
  invalidUsernameNoLetterOrNumber,
  invalidOnlyNumbers,
}

enum EmailInputError {
  nullValue,
  empty,
  invalid,
  errorPostServerRequest,
  serverErrorMessage,
}

enum PasswordInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  missingNumber,
  missingSymbol,
  errorPostServerRequest,
  inputDoesNotMatch,
  serverErrorMessage,
  missingCapitalLetter,
}

enum UrlInputError {
  nullValue,
  empty,
  invalid,
  serverErrorMessage,
}

enum OtpInputError {
  nullValue,
  empty,
  invalidLength,
  invalidCharacters,
  serverErrorMessage,
  errorPostServerRequest,
}

enum PhoneInputError {
  nullValue,
  empty,
  invalid,
  errorPostServerRequest,
  serverErrorMessage,
  invalidLength,
  invalidCharacters,
}

enum TitleInputError {
  onlyNumbersNotAllowed,
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  serverErrorMessage,
  cursedWords,
  invalidEnglishSentence,
  invalidOnlyNumbers,
}

enum DurationInDaysInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  onlyNumbersNotAllowed,
}

enum CourseFeeInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  onlyNumbersNotAllowed,
}

enum CourseHighlightsInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  onlyNumbersNotAllowed,
  serverErrorMessage,
}

enum GstInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  onlyNumbersNotAllowed,
  serverErrorMessage,
}

enum DurationInHoursInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  onlyNumbersNotAllowed,
}

enum CourseCurriculumInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  onlyNumbersNotAllowed,
  serverErrorMessage,
}

enum CourseOverviewInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  onlyNumbersNotAllowed,
}

enum MinimumAgeInputError {
  empty,
  errorPostServerRequest,
  serverErrorMessage,
  tooShort,
  tooLong,
  invalidInteger,
}

enum MaximumAgeInputError {
  empty,
  errorPostServerRequest,
  serverErrorMessage,
  tooShort,
  tooLong,
  invalidInteger,
}

enum ShortTitleInputError {
  onlyNumbersNotAllowed,
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  serverErrorMessage,
  invalidEnglishSentence,
  invalidOnlyNumbers,
}

enum CategoryScopeInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  serverErrorMessage,
}

enum DescriptionInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  serverErrorMessage,
}

enum CourseFeatureInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  serverErrorMessage,
}

enum NameInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  serverErrorMessage,
  required,
}

enum LastNameInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  serverErrorMessage,
  required,
}

enum CityNameInputError {
  nullValue,
  empty,
  tooShort,
  tooLong,
  errorPostServerRequest,
  serverErrorMessage,
  required,
}
