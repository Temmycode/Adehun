import 'package:adehun_mvp/domain/models/agreement_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/usecases/accept_agreement.dart';
import 'package:adehun_mvp/usecases/create_agreement.dart';
import 'package:adehun_mvp/usecases/get_agreement.dart';
import 'package:adehun_mvp/usecases/get_all_agreements.dart';
import 'package:adehun_mvp/usecases/params/create_agreement_params.dart';
import 'package:flutter/widgets.dart';

class AgreementController extends ChangeNotifier {
  final GetAllAgreementsUseCase getAllAgreementsUseCase;
  final CreateAgreementUseCase createAgreementUseCase;
  final AcceptAgreementUseCase acceptAgreementUseCase;
  final GetAgreementUseCase getAgreementUseCase;

  AgreementController({
    required this.getAllAgreementsUseCase,
    required this.createAgreementUseCase,
    required this.acceptAgreementUseCase,
    required this.getAgreementUseCase,
  });

  bool _isLoading = false;
  List<AgreementResponse> _agreements = [];
  AgreementResponse? _selectedAgreement;

  // GETTERS
  bool get isLoading => _isLoading;
  List<AgreementResponse> get agreements => _agreements;
  AgreementResponse? get selectedAgreement => _selectedAgreement;

  // SETTERS
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set agreements(List<AgreementResponse> value) {
    _agreements = value;
    notifyListeners();
  }

  set selectedAgreement(AgreementResponse? value) {
    _selectedAgreement = value;
    notifyListeners();
  }

  Future<void> getAllAgreements() async {
    try {
      isLoading = true;

      final dataState = await getAllAgreementsUseCase();

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
        return;
      }

      agreements = dataState.data!;
    } catch (e) {
      print("An error occurred while fetching agreements: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> createAgreement(CreateAgreementParams params) async {
    try {
      isLoading = true;

      final dataState = await createAgreementUseCase(params: params);

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
      print("An error occurred while creating agreement: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> acceptAgreement(String agreementId) async {
    try {
      isLoading = true;

      final dataState = await acceptAgreementUseCase(params: agreementId);

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
      print("An error occurred while accepting agreement: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> getAgreement(String agreementId) async {
    try {
      isLoading = true;

      final dataState = await getAgreementUseCase(params: agreementId);

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
        return;
      }

      selectedAgreement = dataState.data!;
    } catch (e) {
      print("An error occurred while fetching agreement: $e");
    } finally {
      isLoading = false;
    }
  }
}
