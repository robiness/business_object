/*
The desired result for generating the business object with the invoice.dart
*/
import 'package:business_object/business_object.dart';

import 'invoice.dart';

class InvoiceForm extends BusinessFormObject<Invoice> {
  InvoiceForm({
    required super.label,
    required this.name,
    required this.amount,
    required this.customer,
    required this.status,
  }) : super(content: [name, amount, customer, status]);

  final BusinessFormValue<String> name;
  final BusinessFormValue<int> amount;
  final BusinessFormValue<Customer?> customer;
  final BusinessFormValue<InvoiceStatus> status;

  @override
  BusinessFormObject<Invoice> create(Invoice? invoice) {
    return InvoiceForm(
      label: 'invoice',
      name: BusinessFormValue(
        label: 'name',
        initialValue: invoice?.name ?? '',
      ),
      amount: BusinessFormValue(
        label: 'name',
        initialValue: invoice?.amount ?? 5,
      ),
      customer: BusinessFormValue(
        label: 'name',
        initialValue: invoice?.customer,
      ),
      status: BusinessFormValue(
        label: 'name',
        initialValue: invoice?.status ?? InvoiceStatus.pending,
      ),
    );
  }
}

class CustomerBusinessObject extends BusinessFormObject<Customer> {
  CustomerBusinessObject({
    required super.label,
    required this.name,
    required this.address,
  }) : super(content: [name, address]);

  final BusinessFormValue<String> name;
  final BusinessFormValue<String> address;

  @override
  BusinessFormObject<Customer> create(Customer? model) {
    return CustomerBusinessObject(
      label: 'customer',
      name: BusinessFormValue(
        label: 'name',
        initialValue: model?.name ?? '',
      ),
      address: BusinessFormValue(
        label: 'address',
        initialValue: model?.address ?? '',
      ),
    );
  }
}
