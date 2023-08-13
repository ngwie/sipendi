class StringValidation {
  static bool isEmpty(String? value) {
    return value == null || value == '';
  }

  static bool isValidPhone(String? value) {
    if (isEmpty(value)) return true;

    final phoneRegExp = RegExp(r'^0[0-9]{9,13}$');
    return phoneRegExp.hasMatch(value!);
  }
}
