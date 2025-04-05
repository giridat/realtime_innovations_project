import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:realtime_innovations_project/common/json_keys_name.dart';
import 'package:realtime_innovations_project/services_config/local_db/hive/hive_types.dart';
// ignore_for_file: invalid_annotation_target

part 'employee_details_model.g.dart';

@HiveType(typeId: HiveTypes.employeeBoxId)
class EmployeeDetailsViewModel extends HiveObject {
  EmployeeDetailsViewModel({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final String startDate;

  @HiveField(4)
  final String endDate;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  factory EmployeeDetailsViewModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailsViewModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'startDate': startDate,
    'endDate': endDate,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  EmployeeDetailsViewModel copyWith({
    String? id,
    String? name,
    String? role,
    String? startDate,
    String? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmployeeDetailsViewModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
