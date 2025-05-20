// cart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model classes for better type safety
class CartItem {
  final String id;
  final String name;
  final String serviceType;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.price,
    required this.quantity,
  });

  // Create a copy of the current item with updated fields
  CartItem copyWith({
    String? id,
    String? name,
    String? serviceType,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      serviceType: serviceType ?? this.serviceType,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  final List<CartItem> items;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final String? pickupTimeSlot;
  final String? deliveryTimeSlot;
  final String specialInstructions;

  CartState({
    required this.items,
    required this.pickupDate,
    required this.deliveryDate,
    this.pickupTimeSlot,
    this.deliveryTimeSlot,
    this.specialInstructions = '',
  });

  // Calculate totals
  double get subtotal => items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  double get deliveryFee => 10.0;
  double get tax => subtotal * 0.15;
  double get total => subtotal + deliveryFee + tax;

  // Create a copy of the current state with updated fields
  CartState copyWith({
    List<CartItem>? items,
    DateTime? pickupDate,
    DateTime? deliveryDate,
    String? pickupTimeSlot,
    String? deliveryTimeSlot,
    String? specialInstructions,
  }) {
    return CartState(
      items: items ?? this.items,
      pickupDate: pickupDate ?? this.pickupDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      pickupTimeSlot: pickupTimeSlot ?? this.pickupTimeSlot,
      deliveryTimeSlot: deliveryTimeSlot ?? this.deliveryTimeSlot,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(
    items: [
      CartItem(
        id: '1',
        name: 'Bedsheets',
        serviceType: 'Wash & Iron',
        price: 15.0,
        quantity: 2,
      ),
      CartItem(
        id: '2',
        name: 'Pillows',
        serviceType: 'Wash & Dry',
        price: 10.0,
        quantity: 4,
      ),
    ],
    pickupDate: DateTime.now(),
    deliveryDate: DateTime.now().add(const Duration(days: 1)),
  ));

  // Add an item to the cart or update quantity if it already exists
  void addItem(CartItem item) {
    final itemIndex = state.items.indexWhere((i) => i.id == item.id);
    if (itemIndex >= 0) {
      // Item exists, update quantity
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
        quantity: updatedItems[itemIndex].quantity + item.quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  // Update the quantity of an item in the cart
  void updateItemQuantity(String id, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(id);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.id == id) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  // Remove an item from the cart
  void removeItem(String id) {
    final updatedItems = state.items.where((item) => item.id != id).toList();
    state = state.copyWith(items: updatedItems);
  }

  // Clear all items from the cart
  void clearCart() {
    state = state.copyWith(items: []);
  }

  // Update pickup date and time
  void setPickup(DateTime date, String timeSlot) {
    state = state.copyWith(
      pickupDate: date,
      pickupTimeSlot: timeSlot,
    );
  }

  void initializeWithVendor(String vendorId, String vendorName, String vendorImage, String vendorDistance) {
    state = CartState(
      items: [],
      pickupDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
      // You might want to add vendor info to your CartState if needed
    );
  }

  // Update delivery date and time
  void setDelivery(DateTime date, String timeSlot) {
    state = state.copyWith(
      deliveryDate: date,
      deliveryTimeSlot: timeSlot,
    );
  }

  // Update special instructions
  void setSpecialInstructions(String instructions) {
    state = state.copyWith(specialInstructions: instructions);
  }
}

// Create a provider that can be accessed throughout the app
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});