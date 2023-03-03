import 'package:example/src/invoice_form.dart';
import 'package:example/src/models/invoice.dart';
import 'package:example/src/models/invoice_form_data.dart';
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
      home: FormScreen(),
    );
  }
}

class FormScreen extends StatelessWidget {
  FormScreen({Key? key}) : super(key: key);

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
              const SizedBox(height: 48),
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
