class Invoice {
  const Invoice({
    required this.name,
    required this.amount,
    required this.customer,
    required this.status,
  });

  final String name;
  final int amount;
  final Customer customer;
  final InvoiceStatus status;
}

enum InvoiceStatus {
  pending,
  paid,
}

class Customer {
  const Customer({
    required this.name,
    required this.address,
  });

  final String name;
  final String address;
}

String invoiceString = '''
class Invoice {
  const Invoice({
    required this.name,
    required this.amount,
    required this.customer,
    required this.status,
  });

  final String name;
  final int amount;
  final Customer customer;
  final InvoiceStatus status;
}

enum InvoiceStatus {
  pending,
  paid,
}

class Customer {
  const Customer({
    required this.name,
    required this.address,
  });

  final String name;
  final String address;
}
''';
