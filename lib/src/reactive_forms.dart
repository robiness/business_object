import 'package:reactive_forms/reactive_forms.dart';

/// Represents a control value accessor that convert between data types
/// [int] and [String].
class NullableIntValueAccessor extends ControlValueAccessor<int?, String> {
  @override
  String modelToViewValue(int? modelValue) {
    return modelValue == null ? '' : modelValue.toString();
  }

  @override
  int? viewToModelValue(String? viewValue) {
    return (viewValue == '' || viewValue == null)
        ? null
        : int.tryParse(viewValue);
  }
}
