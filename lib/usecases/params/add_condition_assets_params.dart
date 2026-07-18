class AddConditionAssetsParams {
  final String conditionId;
  final List<Map<String, String>> files;

  const AddConditionAssetsParams({
    required this.conditionId,
    required this.files,
  });
}
