class ReminderModel {
  final int id;
  final String userId;
  final bool active;
  final String startDate;
  final String className;
  final String? classContext;
  final int? classContextId;
  final String recurrenceType;
  final int recurrenceFrequency;
  final String? notes;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.active,
    required this.startDate,
    required this.className,
    this.classContext,
    this.classContextId,
    required this.recurrenceType,
    required this.recurrenceFrequency,
    this.notes,
  });

  factory ReminderModel.fromHash(Map<String, dynamic> data) {
    return ReminderModel(
      id: data['id'],
      userId: data['user_id'],
      active: data['active'],
      startDate: data['start_date'],
      className: data['class'],
      classContext: data['class_context'],
      classContextId: data['class_context_id'],
      recurrenceType: data['recurrence_type'],
      recurrenceFrequency: data['recurrence_frequency'],
      notes: data['notes'],
    );
  }

  static List<ReminderModel> fromHashList(List list) {
    return list.map((item) => ReminderModel.fromHash(item)).toList();
  }
}
