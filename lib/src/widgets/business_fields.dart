import 'package:business_object/business_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BusinessTextField extends StatelessWidget {
  const BusinessTextField({super.key, required this.value});

  final BusinessFormValue<String?> value;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      onChanged: (control) => value.control.updateValue(control.value),
      formControl: value.control,
      decoration: InputDecoration(
        labelText: value.label,
        errorText: value.control.hasErrors
            ? value.control.errors.values.first.toString()
            : null,
      ),
    );
  }
}

class BusinessNumberField extends StatelessWidget {
  const BusinessNumberField({super.key, required this.value});

  final BusinessFormValue<int?> value;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<int?>(
      keyboardType: TextInputType.number,
      onChanged: (control) => value.control.updateValue(control.value),
      formControl: value.control,
      decoration: InputDecoration(
        labelText: value.label,
        errorText: value.control.hasErrors
            ? value.control.errors.values.first.toString()
            : null,
      ),
      valueAccessor: NullableIntValueAccessor(),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}

class BusinessSelectionField extends StatefulWidget {
  const BusinessSelectionField({
    super.key,
    required this.value,
  });

  final BusinessSelectionValue value;

  @override
  State<BusinessSelectionField> createState() => _BusinessSelectionFieldState();
}

class _BusinessSelectionFieldState extends State<BusinessSelectionField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: widget.value.control.value,
      onChanged: (dynamic newValue) {
        widget.value.control.updateValue(newValue);
        setState(() {});
      },
      decoration: InputDecoration(
        labelText: widget.value.label,
        errorText: widget.value.control.hasErrors
            ? widget.value.control.errors.values.first.toString()
            : null,
      ),
      items: widget.value.businessOptions
          .map(
            (item) => DropdownMenuItem(
              value: item.value,
              child: Text(item.label),
            ),
          )
          .toList(),
    );
  }
}

class BusinessSliderField extends StatelessWidget {
  const BusinessSliderField({
    super.key,
    required this.value,
  });

  final BusinessSelectionValue<double?> value;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value.control.value ?? 0,
      onChanged: (double newValue) {
        value.control.updateValue(newValue);
      },
    );
  }
}
