import 'dart:developer';
import 'dart:io';

import 'package:adehun_mvp/constants/errors.dart';
import 'package:adehun_mvp/core/resources/data_state.dart';
import 'package:adehun_mvp/data/services/notification_api_service.dart';
import 'package:adehun_mvp/domain/models/mark_read_request.dart';
import 'package:adehun_mvp/domain/models/notification_list_response.dart';
import 'package:adehun_mvp/domain/notification_repository.dart';
import 'package:flutter/foundation.dart';

class NotificationRepoImpl implements NotificationRepository {
  final NotificationApiService _notificationApiService;

  const NotificationRepoImpl(NotificationApiService apiService)
    : _notificationApiService = apiService;

  @override
  Future<DataState<NotificationListResponse>> getNotifications({
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final apiResponse = await _notificationApiService.getNotifications(
        skip: skip,
        limit: limit,
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data);
      }

      return DataFailed(GetNotificationsError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<int>> getUnreadCount() async {
    try {
      final apiResponse = await _notificationApiService.getUnreadCount();

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data.unreadCount);
      }

      return DataFailed(GetUnreadCountError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<int>> markAsRead(List<String> notificationIds) async {
    try {
      final apiResponse = await _notificationApiService.markAsRead(
        MarkReadRequest(notificationIds: notificationIds),
      );

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data.updatedCount);
      }

      return DataFailed(MarkNotificationsReadError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }

  @override
  Future<DataState<int>> markAllAsRead() async {
    try {
      final apiResponse = await _notificationApiService.markAllAsRead();

      if (apiResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(apiResponse.data.updatedCount);
      }

      return DataFailed(MarkAllNotificationsReadError());
    } catch (err, stk) {
      if (kDebugMode) {
        log('$err, $stk');
      }
      rethrow;
    }
  }
}
