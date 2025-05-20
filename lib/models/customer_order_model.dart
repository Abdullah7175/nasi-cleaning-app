class CustomerOrder {
  final String id;
  final DateTime date;
  final String status;
  final List<OrderItem> items;
  final double total;
  final Vendor vendor;
  final String deliveryTime;
  final TrackingInfo trackingInfo;

  CustomerOrder({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.total,
    required this.vendor,
    required this.deliveryTime,
    required this.trackingInfo,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class Vendor {
  final String name;
  final String address;

  Vendor({
    required this.name,
    required this.address,
  });
}

class TrackingInfo {
  final bool picked;
  final bool cleaning;
  final bool delivery;
  final bool delivered;

  TrackingInfo({
    required this.picked,
    required this.cleaning,
    required this.delivery,
    required this.delivered,
  });
}