/// Pure routing decision, kept free of Flutter so it can be unit tested.
///
/// Returns the location to redirect to, or `null` to allow [location].
String? computeRedirect({
  required String location,
  required bool hasSession,
  required bool needsProfile,
  required bool isFirstLaunch,
}) {
  final path = Uri.parse(location).path;

  const alwaysAllowed = {'/splash', '/invite'};
  const publicOnly = {'/onboarding', '/auth'};

  if (alwaysAllowed.contains(path)) return null;

  if (!hasSession) {
    if (publicOnly.contains(path)) return null;
    if (path == '/profile-completion') return '/auth';
    return isFirstLaunch ? '/onboarding' : '/auth';
  }

  // Signed in from here on.
  if (needsProfile) {
    return path == '/profile-completion' ? null : '/profile-completion';
  }
  if (publicOnly.contains(path) || path == '/profile-completion') {
    return '/home';
  }
  return null;
}
