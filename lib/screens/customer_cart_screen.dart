// Updated cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';

class CustomerCartScreen extends ConsumerStatefulWidget {
  const CustomerCartScreen({super.key});

  @override
  ConsumerState<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class Vendor {
  final String name;
  final String image;
  final String distance;

  Vendor({
    required this.name,
    required this.image,
    required this.distance,
  });
}

class _CustomerCartScreenState extends ConsumerState<CustomerCartScreen> {
  // State for special instructions and coupon
  final TextEditingController _specialInstructionsController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();

  // Vendor data
  final _vendor = Vendor(
    name: 'NASI Cleaning Services',
    image: 'lib/assets/logo.png',
    distance: '2.5 km',
  );

  @override
  void initState() {
    super.initState();
    // Initialize special instructions from provider if available
    final cartState = ref.read(cartProvider);
    _specialInstructionsController.text = cartState.specialInstructions;
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _updateItemQuantity(String id, int newQuantity) {
    ref.read(cartProvider.notifier).updateItemQuantity(id, newQuantity);
  }

  void _clearCart() {
    ref.read(cartProvider.notifier).clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cart cleared')),
    );
  }

  void _applyCoupon() {
    if (_couponController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon code')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid coupon code')),
    );
  }

  void _proceedToCheckout() {
    // Save special instructions before proceeding
    ref.read(cartProvider.notifier).setSpecialInstructions(_specialInstructionsController.text);

    final cartState = ref.read(cartProvider);
    if (cartState.pickupTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a pickup time slot')),
      );
      return;
    }

    if (cartState.deliveryTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery time slot')),
      );
      return;
    }

    context.go('/checkout');
  }

  Future<void> _selectDate(BuildContext context, bool isPickup) async {
    final cartState = ref.read(cartProvider);
    final initialDate = isPickup ? cartState.pickupDate : cartState.deliveryDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final cartNotifier = ref.read(cartProvider.notifier);
      if (isPickup) {
        final timeSlot = cartState.pickupTimeSlot ?? '';
        cartNotifier.setPickup(picked, timeSlot);
      } else {
        final timeSlot = cartState.deliveryTimeSlot ?? '';
        cartNotifier.setDelivery(picked, timeSlot);
      }
    }
  }

  Future<void> _selectTimeSlot(BuildContext context, bool isPickup) async {
    final timeSlots = ['9:00 AM', '12:00 PM', '3:00 PM', '6:00 PM'];

    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${isPickup ? 'Pickup' : 'Delivery'} Time'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(timeSlots[index]),
                onTap: () => Navigator.pop(context, timeSlots[index]),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null) {
      final cartNotifier = ref.read(cartProvider.notifier);
      final cartState = ref.read(cartProvider);

      if (isPickup) {
        cartNotifier.setPickup(cartState.pickupDate, selected);
      } else {
        cartNotifier.setDelivery(cartState.deliveryDate, selected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the cart state for changes
    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: cartItems.isNotEmpty ? _clearCart : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Vendor Card
                  if (cartItems.isNotEmpty) _buildVendorCard(),
                  const SizedBox(height: 16),

                  // Cart Items
                  if (cartItems.isEmpty)
                    _buildEmptyCart()
                  else
                    _buildCartItems(cartItems),

                  const SizedBox(height: 16),

                  // Special Instructions
                  if (cartItems.isNotEmpty) _buildSpecialInstructions(),

                  const SizedBox(height: 16),

                  // Schedule Pickup/Delivery
                  if (cartItems.isNotEmpty) _buildScheduleSection(cartState),

                  const SizedBox(height: 16),

                  // Coupon Input
                  if (cartItems.isNotEmpty) _buildCouponInput(),
                ],
              ),
            ),
          ),

          // Order Summary
          if (cartItems.isNotEmpty) _buildOrderSummary(
              cartState.subtotal,
              cartState.deliveryFee,
              cartState.tax,
              cartState.total
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                _vendor.image,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _vendor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_vendor.distance} away',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Your cart is empty',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home/vendors'),
              child: const Text('Browse Services'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems(List<CartItem> cartItems) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ...cartItems.map((item) => Padding(
            padding: const EdgeInsets.all(16),
            child: _buildCartItem(item),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.serviceType,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${item.price.toStringAsFixed(2)} SAR',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => _updateItemQuantity(item.id, item.quantity - 1),
            ),
            Text(item.quantity.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _updateItemQuantity(item.id, item.quantity + 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecialInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special Instructions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _specialInstructionsController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Any special requests for your laundry...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection(CartState cartState) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTimeSlotSelector(
            'Schedule Pickup',
            cartState.pickupDate,
            cartState.pickupTimeSlot,
            true,
          ),
          const Divider(height: 1),
          _buildTimeSlotSelector(
            'Schedule Delivery',
            cartState.deliveryDate,
            cartState.deliveryTimeSlot,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSelector(String title, DateTime date, String? timeSlot, bool isPickup) {
    final formattedDate = DateFormat('MMM d, yyyy').format(date);
    final displayText = timeSlot != null ? '$formattedDate, $timeSlot' : 'Select time';

    return InkWell(
      onTap: () => _selectTimeSlot(context, isPickup),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  displayText,
                  style: TextStyle(
                    color: timeSlot != null ? Colors.black : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponInput() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                decoration: InputDecoration(
                  hintText: 'Enter coupon code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _applyCoupon,
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double deliveryFee, double tax, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', subtotal.toStringAsFixed(2) + ' SAR'),
          _buildSummaryRow('Delivery Fee', deliveryFee.toStringAsFixed(2) + ' SAR'),
          _buildSummaryRow('VAT (15%)', tax.toStringAsFixed(2) + ' SAR'),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildSummaryRow('Total', total.toStringAsFixed(2) + ' SAR', bold: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _proceedToCheckout,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}