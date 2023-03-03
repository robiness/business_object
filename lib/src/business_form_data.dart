import 'package:reactive_forms/reactive_forms.dart';

/// A object which represents a complex business object (e.g. a customer, an invoice, etc.)
abstract class BusinessObject {
  final String label;

  const BusinessObject({required this.label});
}

abstract class BusinessFormGroup<T> extends BusinessObject {
  const BusinessFormGroup({
    required this.content,
    required super.label,
  });

  final List<BusinessObject> content;

  FormGroup get formGroup {
    final models = Map.fromEntries(
      content.whereType<BusinessFormGroup>().map(
            (e) => MapEntry(e.label, e.formGroup),
          ),
    );
    final values = Map.fromEntries(
      content.whereType<BusinessFormValue>().map(
            (e) => MapEntry(e.label, e.control),
          ),
    );
    return FormGroup({
      ...models,
      ...values,
    });
  }

  @override
  String toString() {
    return formGroup.value.toString();
  }
}

/// A value in a [BusinessObject]
class BusinessFormValue<T> extends BusinessObject {
  BusinessFormValue({
    required this.initialValue,
    required super.label,
    this.validators = const [],
  }) : control = FormControl<T>(value: initialValue, validators: validators);

  final T initialValue;
  final FormControl<T> control;
  final List<ValidatorFunction> validators;

  @override
  String toString() {
    return control.value.toString();
  }
}

/// A [BusinessFormValue] that can be selected from a list of options
class BusinessSelectionValue<T> extends BusinessFormValue<T> {
  BusinessSelectionValue({
    required this.options,
    required super.initialValue,
    required super.label,
    super.validators,
  });

  final List<T> options;

  List<BusinessOption> get businessOptions {
    return options.map((e) {
      return BusinessOption(value: e, label: e.toString());
    }).toList();
  }
}

/// An option in a [BusinessSelectionValue]
class BusinessOption<T> {
  const BusinessOption({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}
