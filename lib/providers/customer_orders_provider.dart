import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer_order_model.dart';

final customerOrdersProvider = StateNotifierProvider<CustomerOrdersNotifier, List<CustomerOrder>>((ref) {
  return CustomerOrdersNotifier();
});

class CustomerOrdersNotifier extends StateNotifier<List<CustomerOrder>> {
  CustomerOrdersNotifier() : super([]);

  void loadSampleOrders() {
    state = [
      CustomerOrder(
        id: "ORD-1234",
        date: DateTime(2025, 4, 29, 10, 30),
        status: "delivered",
        items: [
          OrderItem(name: "T-Shirts", quantity: 3, price: 6),
          OrderItem(name: "Pants", quantity: 2, price: 8),
        ],
        total: 34,
        vendor: Vendor(
          name: "NASI Cleaning Services",
          address: "123 Abdullah Street, Riyadh",
        ),
        deliveryTime: "Apr 29, 10:30 AM",
        trackingInfo: TrackingInfo(
          picked: true,
          cleaning: true,
          delivery: true,
          delivered: true,
        ),
      ),
      CustomerOrder(
        id: "ORD-1235",
        date: DateTime(2025, 4, 28, 14, 45),
        status: "in_progress",
        items: [
          OrderItem(name: "Dress Shirts", quantity: 4, price: 7),
          OrderItem(name: "Suits", quantity: 1, price: 15),
        ],
        total: 43,
        vendor: Vendor(
          name: "NASI Cleaning Services",
          address: "123 Abdullah Street, Riyadh",
        ),
        deliveryTime: "Apr 30, 2:00 PM",
        trackingInfo: TrackingInfo(
          picked: true,
          cleaning: true,
          delivery: false,
          delivered: false,
        ),
      ),
      CustomerOrder(
        id: "ORD-1236",
        date: DateTime(2025, 4, 27, 9, 15),
        status: "scheduled",
        items: [
          OrderItem(name: "Bedsheets", quantity: 2, price: 12),
          OrderItem(name: "Curtains", quantity: 4, price: 18),
        ],
        total: 96,
        vendor: Vendor(
          name: "NASI Cleaning Services",
          address: "123 Abdullah Street, Riyadh",
        ),
        deliveryTime: "Apr 30, 4:30 PM",
        trackingInfo: TrackingInfo(
          picked: false,
          cleaning: false,
          delivery: false,
          delivered: false,
        ),
      ),
    ];
  }
}