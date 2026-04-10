import 'package:adehun_mvp/domain/models/agreement_stats_response.dart';
import 'package:adehun_mvp/resources/data_state.dart';
import 'package:adehun_mvp/usecases/get_user_agreement_stats.dart';
import 'package:flutter/widgets.dart';

class StatsController extends ChangeNotifier {
  final GetUserAgreementStatsUseCase getUserAgreementStatsUseCase;

  StatsController({required this.getUserAgreementStatsUseCase});

  bool _isLoading = false;
  AgreementStatsResponse _agreementStats = AgreementStatsResponse.empty();

  // GETTERS
  bool get isLoading => _isLoading;
  AgreementStatsResponse get agreementStats => _agreementStats;

  // SETTERS
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set agreementStats(AgreementStatsResponse value) {
    _agreementStats = value;
    notifyListeners();
  }

  Future<void> getUserAgreementStats() async {
    try {
      isLoading = true;

      final dataState = await getUserAgreementStatsUseCase();

      if (dataState is DataFailed) {
        // Handle failure
        return;
      }

      if (dataState is DataSuccess && dataState.data == null) {
        // Handle failure
        return;
      }

      agreementStats = dataState.data!;
    } catch (e) {
      print("An error occurred while fetching agreement stats: $e");
    } finally {
      isLoading = false;
    }
  }
}
