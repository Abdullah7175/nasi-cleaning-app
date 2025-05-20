import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/order_model.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]);

  // Update payment details for a specific order
  Future<void> updatePayment(int orderId, Map<String, dynamic> paymentData) async {
    state = [
      for (final order in state)
        if (order.id == orderId)
          order.copyWith(
            paymentMethod: paymentData['paymentMethod'],
            paymentStatus: paymentData['paymentStatus'],
          )
        else
          order
    ];
  }

  // Load sample orders with proper coordinates
  void loadSampleOrders() {
    state = [
      Order(
        id: 1,
        orderNumber: 'ORD-12345',
        status: 'assigned',
        customerName: 'Ahmed Residence',
        customerAddress: '123 Main St, Riyadh, Saudi Arabia',
        latitude: 24.7136,  // Riyadh coordinates
        longitude: 46.6753,
        customerPhone: '+966501234567',
        totalAmount: 7500,
        itemCount: 3,
        orderType: 'pickup',
        paymentMethod: 'cash',
        paymentStatus: 'pending',
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        completedAt: null,
        items: [
          {'name': 'Queen Bedsheet', 'quantity': 2, 'price': 2500},
          {'name': 'Pillow Covers', 'quantity': 1, 'price': 2500},
        ],
      ),
      Order(
        id: 2,
        orderNumber: 'ORD-12346',
        status: 'in_progress',
        customerName: 'Mohammed Apartment',
        customerAddress: '456 Second Ave, Jeddah',
        latitude: 21.5433,  // Jeddah coordinates
        longitude: 39.1728,
        customerPhone: '+966502345678',
        totalAmount: 12000,
        itemCount: 2,
        orderType: 'delivery',
        paymentMethod: 'card',
        paymentStatus: 'paid',
        scheduledDate: null,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        completedAt: null,
        items: [
          {'name': 'Queen Bedsheet Set', 'quantity': 1, 'price': 7000},
          {'name': 'Duvet Cover', 'quantity': 1, 'price': 5000},
        ],
      ),
      Order(
        id: 3,
        orderNumber: 'ORD-12347',
        status: 'completed',
        customerName: 'Fatima Villa',
        customerAddress: '789 Beach Rd, Dammam',
        latitude: 26.4207,  // Dammam coordinates
        longitude: 50.0888,
        customerPhone: '+966503456789',
        totalAmount: 15000,
        itemCount: 4,
        orderType: 'delivery',
        paymentMethod: 'card',
        paymentStatus: 'paid',
        scheduledDate: null,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
        items: [
          {'name': 'King Bedsheet', 'quantity': 1, 'price': 4000},
          {'name': 'Pillow Cases', 'quantity': 2, 'price': 3000},
          {'name': 'Blanket', 'quantity': 1, 'price': 8000},
        ],
      ),
    ];
  }

  // Start delivery for an order
  void startDelivery(int orderId) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          order.copyWith(
            status: 'in_progress',
            // You can add other fields to update here if needed
          )
        else
          order
    ];
  }

  // Complete an order
  void completeOrder(int orderId) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          order.copyWith(
            status: 'completed',
            completedAt: DateTime.now(),
          )
        else
          order
    ];
  }

  // Cancel an order
  void cancelOrder(int orderId) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          order.copyWith(
            status: 'cancelled',
          )
        else
          order
    ];
  }

  // Get order by ID
  Order? getOrderById(int orderId) {
    try {
      return state.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Update order status
  void updateOrderStatus(int orderId, String newStatus) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          order.copyWith(
            status: newStatus,
          )
        else
          order
    ];
  }
}
