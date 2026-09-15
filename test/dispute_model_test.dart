import 'dart:convert';

import 'package:adehun_mvp/constants/dispute_enums.dart';
import 'package:adehun_mvp/domain/models/dispute_response.dart';
import 'package:flutter_test/flutter_test.dart';

/// A DisputeResponse shaped exactly like the API's schema, evidence included.
Map<String, dynamic> _fullPayload() => {
  'id': 'dispute-1',
  'agreement_id': 'agreement-1',
  'agreement_title': 'Social Media Graphics',
  'agreement_amount': '35000.00',
  'category': 'missed_deadline',
  'description': 'The deliverables were two weeks late and still incomplete.',
  'status': 'under_review',
  'raised_by': {
    'id': 'user-1',
    'name': 'Ada Lovelace',
    'email': 'ada@example.com',
    'phone_number': null,
    'profile_picture_url': null,
  },
  'against_user': {
    'id': 'user-2',
    'name': 'Grace Hopper',
    'email': 'grace@example.com',
  },
  'resolution_outcome': null,
  'resolution_notes': null,
  'resolved_by': null,
  'resolved_at': null,
  'created_at': '2026-08-20T09:30:00Z',
  'updated_at': '2026-08-20T10:00:00Z',
  'evidence': [
    {
      'id': 'asset-1',
      'is_approved': false,
      'uploader': {
        'id': 'participant-1',
        'agreement_id': 'agreement-1',
        'role': 'depositor',
        'status': 'accepted',
        'user': {
          'id': 'user-1',
          'name': 'Ada Lovelace',
          'email': 'ada@example.com',
        },
      },
      'file': {
        'id': 'file-1',
        'url': 'https://res.cloudinary.com/demo/image/upload/proof.png',
        'type': 'image',
        'name': 'proof.png',
        'size': 20481.0,
      },
    },
  ],
};

void main() {
  test('decodes the full API payload', () {
    final dispute = DisputeResponse.fromJson(_fullPayload());

    expect(dispute.id, 'dispute-1');
    expect(dispute.agreementTitle, 'Social Media Graphics');
    expect(dispute.agreementAmount, '35000.00');
    expect(dispute.category, DisputeCategory.missedDeadline);
    expect(dispute.status, DisputeStatus.underReview);
    expect(dispute.raisedBy?.name, 'Ada Lovelace');
    expect(dispute.againstUser?.email, 'grace@example.com');
    expect(dispute.resolutionOutcome, isNull);
    expect(dispute.createdAt, DateTime.parse('2026-08-20T09:30:00Z'));
    expect(dispute.evidence, hasLength(1));
    expect(dispute.evidence!.first.file.name, 'proof.png');
    expect(dispute.isLive, isTrue);
  });

  test('resolved disputes are not live and carry their outcome', () {
    final dispute = DisputeResponse.fromJson({
      ..._fullPayload(),
      'status': 'resolved',
      'resolution_outcome': 'favour_depositor',
      'resolution_notes': 'Evidence supported the depositor.',
      'resolved_at': '2026-08-21T12:00:00Z',
    });

    expect(dispute.status, DisputeStatus.resolved);
    expect(dispute.isLive, isFalse);
    expect(dispute.resolutionOutcome, DisputeResolutionOutcome.favourDepositor);
    expect(dispute.resolvedAt, DateTime.parse('2026-08-21T12:00:00Z'));
  });

  test('open disputes are live', () {
    final dispute = DisputeResponse.fromJson({
      ..._fullPayload(),
      'status': 'open',
    });

    expect(dispute.isLive, isTrue);
  });

  test('an omitted evidence list decodes as empty, not null', () {
    final payload = _fullPayload()..remove('evidence');

    expect(DisputeResponse.fromJson(payload).evidence, isEmpty);
  });

  // The cache decodes blobs written by older builds, so an enum value the app
  // has never seen must degrade one field rather than throw.
  test('unknown enum values fall back instead of throwing', () {
    final dispute = DisputeResponse.fromJson({
      ..._fullPayload(),
      'category': 'newly_added_category',
      'status': 'newly_added_status',
    });

    expect(dispute.category, DisputeCategory.unknown);
    expect(dispute.status, DisputeStatus.unknown);
    expect(dispute.isLive, isFalse);
  });

  // Mirrors what LocalDataCacheManager actually does: jsonEncode(toJson()) on
  // the way in, jsonDecode + fromJson on the way out.
  test('survives a cache round trip', () {
    final original = DisputeResponse.fromJson(_fullPayload());
    final encoded = jsonEncode(original.toJson());
    final restored = DisputeResponse.fromJson(
      jsonDecode(encoded) as Map<String, dynamic>,
    );

    expect(restored.id, original.id);
    expect(restored.category, original.category);
    expect(restored.status, original.status);
    expect(restored.raisedBy?.name, 'Ada Lovelace');
    expect(restored.createdAt, original.createdAt);
    expect(restored.evidence, hasLength(1));
    expect(
      restored.evidence!.first.file.url,
      original.evidence!.first.file.url,
    );
  });

  test('category wire values match the API enum', () {
    expect(DisputeCategory.qualityIssues.wire, 'quality_issues');
    expect(DisputeCategory.missedDeadline.wire, 'missed_deadline');
    expect(DisputeCategory.incompleteWork.wire, 'incomplete_work');
    expect(DisputeCategory.nonResponsive.wire, 'non_responsive');
    expect(DisputeCategory.other.wire, 'other');
  });

  test('the unknown placeholder is never offered as a choice', () {
    expect(DisputeCategory.selectable, hasLength(5));
    expect(
      DisputeCategory.selectable,
      isNot(contains(DisputeCategory.unknown)),
    );
  });
}
