class MedicineModel {
  final int id;
  final String name;
  final String? descriptions;

  MedicineModel({
    required this.id,
    required this.name,
    this.descriptions,
  });

  factory MedicineModel.formHash(Map<String, dynamic> data) {
    return MedicineModel(
      id: data['id'],
      name: data['name'],
      descriptions: data['descriptions'],
    );
  }

  static List<MedicineModel> fromHashList(List list) {
    return list.map((item) => MedicineModel.formHash(item)).toList();
  }

  bool isEqual(MedicineModel model) {
    return id == model.id;
  }

  @override
  String toString() => name;
}
