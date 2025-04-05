import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_details_model.dart';
import 'package:realtime_innovations_project/modules/employees/models/employee_request_model.dart';

class FirebaseService {
  Future<T> _withTimeout<T>(
    Future<T> Function() request, {
    required Duration timeoutDuration,
  }) async {
    return request().timeout(
      timeoutDuration,
      onTimeout: () {
        throw Exception(
          'Request timed out',
        );
      },
    );
  }

  Map<String, Object?> _removeNullEmptyKeyValueFromMap(
    Map<String, Object?> inputMap, {
    bool removeNull = true,
    bool removeEmpty = false,
    bool removeNullFromList = false,
    Set<String>? keysToSkipChecking,
  }) {
    if (inputMap.isEmpty || (keysToSkipChecking?.isEmpty ?? false)) {
      return inputMap;
    }

    final keysToRemove = <String>[];
    final resultMap = {...inputMap};

    resultMap.forEach((key, value) {
      final skipKey = keysToSkipChecking?.contains(key) ?? false;
      final isValueNull = value == null;
      final isValueEmptyString = value is String && value.isEmpty;

      if ((removeNull && isValueNull || removeEmpty && isValueEmptyString) &&
          !skipKey) {
        keysToRemove.add(key);
      }

      final isValueListNullOrNuObject = value is List<Object?>;
      if (removeNullFromList && isValueListNullOrNuObject && !skipKey) {
        value.removeWhere((element) => element == null);
      }

      if (value is Map<String, dynamic>) {
        resultMap[key] = _removeNullEmptyKeyValueFromMap(
          value,
          removeNull: removeNull,
          removeEmpty: removeEmpty,
          keysToSkipChecking: keysToSkipChecking,
        );
      }
    });

    keysToRemove.forEach(resultMap.remove);

    return resultMap;
  }

  Future<T> _performRequest<T>(
    Future<T> Function() request, {
    Duration timeoutDuration = const Duration(seconds: 30),
    bool applyTimeout = true,
  }) async {
    final response = applyTimeout
        ? await _withTimeout(request, timeoutDuration: timeoutDuration)
        : await request();
    return response;
  }

  Future<List<QueryDocumentSnapshot>> getDocumentsList({
    required String collectionName,
  }) async {
    final response = await _performRequest(
      () => FirebaseFirestore.instance
          .collection(collectionName)
          .orderBy('updatedAt')
          .get()
          .then(
            (value) => value.docs.toList(),
          ),
    );
    return response;
  }

  Future<Map<String, dynamic>?> getDocument({
    required String collectionName,
    required String documentId,
  }) async {
    final response = await _performRequest(
      () => FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .get()
          .then((value) => value.data()),
    );
    return response;
  }

  Future<bool> updateDocument({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _performRequest(
        () => FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentId)
            .update(data),
      );
      return true;
    } catch (error) {
      // Handle potential errors here
      if (kDebugMode) {
        debugPrint('Error updating document: $error');
      }
      // If you prefer to rethrow the error for further handling:
      // rethrow;

      // Optionally, you can also provide more specific error handling based on the type of error:
      if (error is FirebaseException) {
        // Handle Firebase-specific errors
        if (kDebugMode) {
          debugPrint('Firebase error: ${error.code} - ${error.message}');
        }
        return false;
      } else {
        // Handle other errors
        if (kDebugMode) {
          debugPrint('Unexpected error: $error');
        }
        return false;
      }
    }
  }

  Future<bool> deleteDocument({
    required String collectionName,
    required String documentId,
  }) async {
    try {
      await _performRequest(
        () => FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentId)
            .delete(),
      );
      return true;
    } catch (error) {
      // Handle potential errors here
      if (kDebugMode) {
        debugPrint('Error Deleting document: $error');
      }
      // If you prefer to rethrow the error for further handling:
      // rethrow;

      // Optionally, you can also provide more specific error handling based on the type of error:
      if (error is FirebaseException) {
        // Handle Firebase-specific errors
        if (kDebugMode) {
          debugPrint('Firebase error: ${error.code} - ${error.message}');
        }
        return false;
      } else {
        // Handle other errors
        if (kDebugMode) {
          debugPrint('Unexpected error: $error');
        }
        return false;
      }
    }
  }

  Future<bool> createDocument({
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final jsonObject = data;
      await _performRequest(
        () => FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentId)
            .set(jsonObject, SetOptions(merge: true)),
      );
      return true;
    } catch (error, stackTrace) {
      // Handle potential errors here
      if (kDebugMode) {
        debugPrint('Error creating document: $error \n $stackTrace');
      }
      // If you prefer to rethrow the error for further handling:
      // rethrow;

      // Optionally, you can also provide more specific error handling based on the type of error:
      if (error is FirebaseException) {
        // Handle Firebase-specific errors
        if (kDebugMode) {
          debugPrint('Firebase error: ${error.code} - ${error.message}');
        }
        return false;
      } else {
        // Handle other errors
        if (kDebugMode) {
          debugPrint('Unexpected error: $error \n $stackTrace');
        }
        return false;
      }
    }
  }
}
