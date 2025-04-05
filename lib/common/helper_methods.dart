import 'dart:convert';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';



import 'package:path_provider/path_provider.dart';

import 'instances.dart';

class HelperMethods {
  static DateTime parseUtcDateToLocal(String utcDate) {
    return DateTime.parse(utcDate).toLocal();
  }

  static bool isNotMobilePlatform() {
    if (kIsWeb) {
      return true; // Web is not considered mobile
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return false; // Mobile platforms
    }
    return true; // Other platforms (e.g., desktop, macOS, Linux, etc.)
  }


  // static DateTime? convertFirebaseTimestampToDateTime(Timestamp? timestamp) {
  //   return timestamp?.toDate();
  // }
  static int calculateHoursPerDay(int totalHours, int totalDays) {
    if (totalDays == 0) {
      throw ArgumentError('Total days cannot be zero.');
    }
    return (totalHours / totalDays).round(); // Rounded result
  }

  // Convert days to weeks with rounded result
  static int convertDaysToWeeks(int totalDays) {
    if (totalDays < 0) {
      throw ArgumentError('Total days cannot be negative.');
    }
    return (totalDays / 7).round(); // Rounded result
  }

  static String parseCreatedAt(String createdAt) {
    try {
      // Parse the input string into a DateTime object
      final dateTime = DateTime.parse(createdAt);

      // Format the DateTime into the desired format
      final formattedDate = DateFormat('MMM. d, yyyy hh:mm a').format(dateTime);

      return formattedDate;
    } catch (e) {
      throw FormatException('Invalid date format: $createdAt');
    }
  }

  static int countGraphemeClusters(String input) {
    final regex = RegExp(
      r'(\p{Emoji_Presentation}|\p{Emoji}\uFE0F|\p{Emoji_Modifier_Base}|\p{Emoji_Modifier}|\p{Emoji_Component})|(\p{Extended_Pictographic})|(\P{M}\p{M}*)',
      unicode: true,
      multiLine: true,
    );

    return regex.allMatches(input).length;
  }

  static DateTime parseJsonDateStringToLocal(
    Map<dynamic, dynamic> json,
    String key,
  ) {
    return parseUtcDateToLocal(safeCast<String>(json[key])!);
  }

  static T? safeCast<T>(dynamic value) {
    // Directly return the value if it is already of the desired type
    if (value is T) {
      return value;
    }

    // Handle List<T> case if the target type is a list
    if (value is List<dynamic> && T is List) {
      try {
        // Attempt to cast the list to the target type
        return value.cast<T>() as T;
      } catch (e) {
        return null;
      }
    }

    // Handle Map<String, dynamic> case
    if (value is Map<String, dynamic> && T is Map) {
      try {
        // Attempt to cast the map to the target type
        return value as T;
      } catch (e) {
        return null;
      }
    }

    // Return null if none of the cases match
    return null;
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    if (!kReleaseMode) {
      pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
    }
  }

  static bool containsWord({
    required String? string,
    required String wordToSearch,
  }) {
    if (string == null) {
      return false;
    }
    return string.toLowerCase().contains(wordToSearch.toLowerCase());
  }

  static T? getTypedValueForKey<T>(
    Map<String, dynamic>? json, {
    required String key,
  }) {
    final value = safeCast<T>(json?[key]);
    return value;
  }

  static T getTypedValueForKeyWithDefault<T>(
    Map<String, dynamic> map, {
    required String key,
    required T defaultValue,
  }) {
    final value = safeCastWithDefault<T>(map[key], defaultValue: defaultValue);
    return value;
  }

  static Map<String, dynamic>? getTypedMapForKey(
    Map<String, dynamic> json, {
    required String key,
  }) {
    return getTypedValueForKey<Map<String, dynamic>>(json, key: key);
  }

  static List<Map<String, dynamic>>? getTypedListMapForKey(
    Map<String, dynamic> json, {
    required String key,
  }) {
    final listDynamic = getTypedValueForKey<List<dynamic>>(json, key: key);

    if (listDynamic == null || listDynamic.isEmpty) {
      return null;
    }

    final list = <Map<String, dynamic>>[];

    for (final item in listDynamic) {
      final map = safeCast<Map<String, dynamic>>(item);

      if (map != null) {
        list.add(map);
      }
    }
    return list;
  }

  static T safeCastWithDefault<T>(dynamic value, {required T defaultValue}) {
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  static String formatDate(String dateString) {
    // Check if the input string is null or empty
    if (dateString.isEmpty) {
      return '';
    }

    // Convert string to DateTime object
    final dateTime = DateTime.parse(dateString);

    // Format DateTime object
    final formattedDate = DateFormat('MMM d, y').format(dateTime);

    return formattedDate;
  }

  static String getTodayFormattedDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMMM yyyy').format(now);
    final formattedDateWithOrdinal = formatOrdinal(formattedDate);
    return formattedDateWithOrdinal;
  }

  static String formatOrdinal(String date) {
    final parts = date.split(' ');
    final day = parts[0];
    final month = parts[1];
    final year = parts[2];
    final ordinalDay = getOrdinal(int.parse(day));
    return '$ordinalDay $month $year';
  }

  static bool isNumeric(String s) {
    if (s.isEmpty) return false;

    // Remove leading '+' and check for multiple decimals
    String sanitized = s.replaceAll("+", "");
    if (sanitized.split('.').length > 2)
      return false; // More than one decimal point

    return double.tryParse(sanitized) != null;
  }

  static String getOrdinal(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  static Widget getImageWidget(String path) {
    // Check if it's an SVG network image
    if (path.endsWith('.svg') &&
        (path.startsWith('http') || path.startsWith('https'))) {
      return SvgPicture.network(
        path,
        placeholderBuilder: (BuildContext context) =>
            const CircularProgressIndicator(),
      );
    }

    // Check if it's a network image (non-SVG)
    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(
        path,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes!)
                  : null,
            ),
          );
        },
        fit: BoxFit.cover,
      );
    }

    // Assume it's a file-based image
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error);
      },
    );
  }


}
