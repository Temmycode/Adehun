import 'package:flutter/foundation.dart';

/// The small amount of auth state the router needs to guard routes.
///
/// Fed by [AuthController] and seeded from secure storage before the first
/// frame, so a cleared token can never leave a stale "logged in" flag routing
/// the user to `/home` with nothing to show.
class AuthRouteNotifier extends ChangeNotifier {
  bool _hasSession = false;
  bool _needsProfile = false;
  bool _isFirstLaunch = true;
  String? _pendingInviteToken;
  String? _redirectAfterLogin;

  bool get hasSession => _hasSession;
  bool get needsProfile => _needsProfile;
  bool get isFirstLaunch => _isFirstLaunch;
  String? get pendingInviteToken => _pendingInviteToken;
  String? get redirectAfterLogin => _redirectAfterLogin;

  void seed({required bool hasSession, required bool isFirstLaunch}) {
    _hasSession = hasSession;
    _isFirstLaunch = isFirstLaunch;
    notifyListeners();
  }

  void setSession({required bool hasSession, bool needsProfile = false}) {
    if (_hasSession == hasSession && _needsProfile == needsProfile) return;
    _hasSession = hasSession;
    _needsProfile = needsProfile;
    notifyListeners();
  }

  void setFirstLaunch(bool value) {
    if (_isFirstLaunch == value) return;
    _isFirstLaunch = value;
    notifyListeners();
  }

  void setPendingInvite(String? token) {
    _pendingInviteToken = token;
  }

  String? consumePendingInvite() {
    final token = _pendingInviteToken;
    _pendingInviteToken = null;
    return token;
  }

  void setRedirectAfterLogin(String? location) {
    _redirectAfterLogin = location;
  }

  String? consumeRedirectAfterLogin() {
    final location = _redirectAfterLogin;
    _redirectAfterLogin = null;
    return location;
  }
}

/// Process-wide singleton: the router is a global too.
final AuthRouteNotifier authRouteNotifier = AuthRouteNotifier();
