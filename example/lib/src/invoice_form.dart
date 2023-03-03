import 'package:business_object/business_object.dart';
import 'package:example/src/models/invoice_form_data.dart';
import 'package:flutter/material.dart';

class InvoiceForm extends StatelessWidget {
  const InvoiceForm({
    Key? key,
    required this.invoiceFormData,
  }) : super(key: key);

  final InvoiceFormData invoiceFormData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Example Form'),
        Row(
          children: [
            Expanded(
              child: BusinessTextField(
                value: invoiceFormData.name,
              ),
            ),
            Expanded(
              child: BusinessNumberField(
                value: invoiceFormData.amount,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        CustomerForm(
          customerFormData: invoiceFormData.customer,
        ),
        const SizedBox(height: 30),
        BusinessSelectionField(
          value: invoiceFormData.status,
        )
      ],
    );
  }
}

class CustomerForm extends StatelessWidget {
  const CustomerForm({
    Key? key,
    required this.customerFormData,
  }) : super(key: key);

  final CustomerFormData customerFormData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Costumer Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: BusinessTextField(
                value: customerFormData.name,
              ),
            ),
            Expanded(
              child: BusinessTextField(
                value: customerFormData.address,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
