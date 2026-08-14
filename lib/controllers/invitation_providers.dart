import 'dart:developer';

import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/domain/models/invitation_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/resources/data_state.dart';

part 'invitation_providers.g.dart';

@riverpod
Future<List<InvitationResponse>> invitedAgreements(Ref ref) async {
  try {
    final dataState = await ref
        .read(agreementRepositoryProvider)
        .getInvitedAgreements();

    if (dataState is DataSuccess && dataState.data != null) {
      return dataState.data!;
    } else {
      return [];
    }
  } catch (err) {
    log('Failed to fetch agreement invitations $err');
    return [];
  }
}
