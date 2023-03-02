import 'package:business_object/business_object.dart';
import 'package:example/src/models/invoice.dart';
import 'package:example/src/models/invoice_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExampleForm(),
    );
  }
}

class ExampleForm extends StatelessWidget {
  ExampleForm({Key? key}) : super(key: key);

  final Invoice invoice = const Invoice(
    name: 'Invoice 01',
    amount: 2,
    customer: Customer(name: 'Customer GmbH', address: 'Customerland'),
    status: InvoiceStatus.pending,
  );

  late final InvoiceFormData invoiceFormData =
      InvoiceFormData.fromInvoice(invoice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              InvoiceForm(
                invoiceFormData: invoiceFormData,
              ),
              TextButton(
                onPressed: () {
                  if (invoiceFormData.formGroup.valid) {
                    print('Form is valid');
                  } else {
                    print('Form is invalid');
                  }
                  print(invoiceFormData.toString());
                },
                child: const Text('Print Invoice Form Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvoiceForm extends StatelessWidget {
  const InvoiceForm({
    Key? key,
    required this.invoiceFormData,
  }) : super(key: key);

  final InvoiceFormData invoiceFormData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Column(
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
          const SizedBox(
            height: 30,
          ),
          CustomerForm(
            customerFormData: invoiceFormData.customer,
          ),
          const SizedBox(
            height: 30,
          ),
          BusinessSelectionField(
            value: invoiceFormData.status,
          )
        ],
      ),
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
