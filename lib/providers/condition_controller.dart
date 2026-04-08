import 'package:adehun_mvp/domain/models/condition_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/usecases/add_condition_to_agreement.dart';
import 'package:adehun_mvp/usecases/approve_condition.dart';
import 'package:adehun_mvp/usecases/get_condition_details.dart';
import 'package:adehun_mvp/usecases/get_users_conditions.dart';
import 'package:adehun_mvp/usecases/params/add_condition_params.dart';
import 'package:adehun_mvp/usecases/params/reject_condition_params.dart';
import 'package:adehun_mvp/usecases/reject_condition.dart';
import 'package:flutter/widgets.dart';

class ConditionController extends ChangeNotifier {
  final AddConditionToAgreementUseCase addConditionToAgreementUseCase;
  final GetUsersConditionsUseCase getUsersConditionsUseCase;
  final GetConditionDetailsUseCase getConditionDetailsUseCase;
  final ApproveConditionUseCase approveConditionUseCase;
  final RejectConditionUseCase rejectConditionUseCase;

  ConditionController({
    required this.addConditionToAgreementUseCase,
    required this.getUsersConditionsUseCase,
    required this.getConditionDetailsUseCase,
    required this.approveConditionUseCase,
    required this.rejectConditionUseCase,
  });

  bool _isLoading = false;
  List<ConditionResponse> _conditions = [];
  ConditionResponse? _selectedCondition;

  // GETTERS
  bool get isLoading => _isLoading;
  List<ConditionResponse> get conditions => _conditions;
  ConditionResponse? get selectedCondition => _selectedCondition;

  // SETTERS
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set conditions(List<ConditionResponse> value) {
    _conditions = value;
    notifyListeners();
  }

  set selectedCondition(ConditionResponse? value) {
    _selectedCondition = value;
    notifyListeners();
  }

  Future<void> addConditionToAgreement(AddConditionParams params) async {
    try {
      isLoading = true;

      final dataState =
          await addConditionToAgreementUseCase(params: params);

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
        return;
      }

      // Handle success
    } catch (e) {
      print("An error occurred while adding condition: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> getUsersConditions() async {
    try {
      isLoading = true;

      final dataState = await getUsersConditionsUseCase();

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
        return;
      }

      conditions = dataState.data!;
    } catch (e) {
      print("An error occurred while fetching conditions: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> getConditionDetails(String conditionId) async {
    try {
      isLoading = true;

      final dataState =
          await getConditionDetailsUseCase(params: conditionId);

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
        return;
      }

      selectedCondition = dataState.data!;
    } catch (e) {
      print("An error occurred while fetching condition details: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> approveCondition(String conditionId) async {
    try {
      isLoading = true;

      final dataState = await approveConditionUseCase(params: conditionId);

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
        return;
      }

      // Handle success
    } catch (e) {
      print("An error occurred while approving condition: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> rejectCondition(RejectConditionParams params) async {
    try {
      isLoading = true;

      final dataState = await rejectConditionUseCase(params: params);

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
        return;
      }

      // Handle success
    } catch (e) {
      print("An error occurred while rejecting condition: $e");
    } finally {
      isLoading = false;
    }
  }
}
