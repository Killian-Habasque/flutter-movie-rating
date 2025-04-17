import 'dart:convert';
import '../../domain/entities/watchlist.dart';

class WatchlistResponseModel {
  final bool success;
  final int statusCode;
  final String statusMessage;

  WatchlistResponseModel({
    required this.success,
    required this.statusCode,
    required this.statusMessage,
  });

  factory WatchlistResponseModel.fromJson(Map<String, dynamic> json) {
    return WatchlistResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      statusMessage: json['status_message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'status_message': statusMessage,
    };
  }

  WatchlistResponse toEntity() {
    return WatchlistResponse(
      success: success,
      statusCode: statusCode,
      statusMessage: statusMessage,
    );
  }
} 