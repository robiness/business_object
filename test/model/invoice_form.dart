/*
The desired result for generating the business object with the invoice.dart
*/
import 'package:business_object/business_object.dart';

import 'invoice.dart';

class InvoiceForm extends BusinessFormGroup<Invoice> {
  InvoiceForm({
    required super.label,
    required this.name,
    required this.amount,
    required this.customer,
    required this.status,
  }) : super(content: [name, amount, customer, status]);

  final BusinessFormValue<String?> name;
  final BusinessFormValue<int?> amount;
  final BusinessFormGroup<Customer?> customer;
  final BusinessFormValue<InvoiceStatus?> status;

  static BusinessFormGroup<Invoice> fromInvoice(Invoice? invoice) {
    return InvoiceForm(
      label: 'invoice',
      name: BusinessFormValue<String?>(
        label: 'name',
        initialValue: invoice?.name,
      ),
      amount: BusinessFormValue(
        label: 'amount',
        initialValue: invoice?.amount,
      ),
      customer: CustomerBusinessObject.fromCustomer(invoice?.customer),
      status: BusinessFormValue(
        label: 'status',
        initialValue: invoice?.status,
      ),
    );
  }
}

class CustomerBusinessObject extends BusinessFormGroup<Customer> {
  CustomerBusinessObject({
    required super.label,
    required this.name,
    required this.address,
  }) : super(content: [name, address]);

  final BusinessFormValue<String?> name;
  final BusinessFormValue<String?> address;

  static BusinessFormGroup<Customer> fromCustomer(Customer? model) {
    return CustomerBusinessObject(
      label: 'customer',
      name: BusinessFormValue(
        label: 'name',
        initialValue: model?.name,
      ),
      address: BusinessFormValue(
        label: 'address',
        initialValue: model?.address,
      ),
    );
  }
}
