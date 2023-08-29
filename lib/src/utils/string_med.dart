const consumptionRuleMap = {
  'before_meal': 'Obat Sebelum Makan',
  'after_meal': 'Obat Setelah Makan',
  'during_meal': 'Obat Saat Makan',
};

const doseUnitMap = {
  'tablet': 'Tablet',
  'capsul': 'Capsul',
  'kaplet': 'Kaplet',
  'tea_spoon': 'Sendok Teh',
  'table_spoon': 'Sendok Makan',
  'ml': 'Miligram',
  'pen': 'Pen',
};

const doseFrequencyTextMap = {
  'hours': ' Jam Sekali',
  'days': ' Hari Sekali',
  'weeks': ' Minggu Sejali',
  'months': ' Bulan Sekali',
};

class StringMed {
  static String consumptionRuleText({String? rule}) {
    if (rule == null) return '';

    return consumptionRuleMap[rule] ?? '';
  }

  static String doseText({int? dose, String? doseUnit}) {
    if (dose == null || doseUnit == null) return '';

    return '$dose ${doseUnitMap[doseUnit]}';
  }

  static String doseFrequencyText({int? freq, String? type}) {
    if (freq == null || type == null) return '';

    return '$freq ${doseFrequencyTextMap[type]}';
  }
}
