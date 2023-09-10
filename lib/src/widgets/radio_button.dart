import 'package:flutter/material.dart';

class RadioButton<T> extends StatelessWidget {
  const RadioButton({
    super.key,
    this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final Widget? label;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(this.value);
      },
      child: Row(
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          label ?? const Text(''),
        ],
      ),
    );
  }
}
