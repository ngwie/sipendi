class MedicineSearchModel {
  final int id;
  final String name;

  MedicineSearchModel({
    required this.id,
    required this.name,
  });

  factory MedicineSearchModel.formHash(Map<String, dynamic> data) {
    return MedicineSearchModel(
      id: data['id'],
      name: data['name'],
    );
  }

  static List<MedicineSearchModel> fromHashList(List list) {
    return list.map((item) => MedicineSearchModel.formHash(item)).toList();
  }

  bool isEqual(MedicineSearchModel model) {
    return id == model.id;
  }

  @override
  String toString() => name;
}
