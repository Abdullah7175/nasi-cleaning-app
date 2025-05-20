import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class CustomerCheckoutScreen extends ConsumerStatefulWidget {
  const CustomerCheckoutScreen({super.key});

  @override
  ConsumerState<CustomerCheckoutScreen> createState() => _CustomerCheckoutScreenState();
}

class _CustomerCheckoutScreenState extends ConsumerState<CustomerCheckoutScreen> {
  String paymentMethod = "card";
  bool showOrderConfirmation = false;
  String orderId = "1234";

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider.notifier);
    final cartState = ref.watch(cartProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _navigateToCart();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Checkout"),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: _navigateToCart,
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDeliveryAddressCard(),
                    const SizedBox(height: 16),
                    _buildOrderSummaryCard(cartState),
                    const SizedBox(height: 16),
                    _buildPaymentMethodCard(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showOrderConfirmation = true;
                    });
                  },
                  child: Text("Place Order - ${cartState.total.toStringAsFixed(2)} SAR"),
                ),
              ),
            ),
            if (showOrderConfirmation) _buildOrderConfirmationDialog(cartState),
          ],
        ),
      ),
    );
  }

  void _navigateToCart() {
    context.go('/cart');
  }

  Widget _buildDeliveryAddressCard() {
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Delivery Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Change",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Home",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "123 Abdullah Street, Al Olaya District",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      "Riyadh, Saudi Arabia",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "+966 5X XXX XXXX",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(CartState cartState) {
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Order Summary",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${cartState.items.length} items from NASI Cleaning",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToCart,
                      child: const Text(
                        "View",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                _buildSummaryRow("Subtotal", "${cartState.subtotal.toStringAsFixed(2)} SAR"),
                _buildSummaryRow("Delivery Fee", "${cartState.deliveryFee.toStringAsFixed(2)} SAR"),
                _buildSummaryRow("VAT (15%)", "${cartState.tax.toStringAsFixed(2)} SAR"),
                const SizedBox(height: 8),
                _buildSummaryRow(
                    "Pickup Time",
                    "${DateFormat('MMM d').format(cartState.pickupDate)}${cartState.pickupTimeSlot != null ? ', ${cartState.pickupTimeSlot}' : ''}"
                ),
                _buildSummaryRow(
                    "Delivery Time",
                    "${DateFormat('MMM d').format(cartState.deliveryDate)}${cartState.deliveryTimeSlot != null ? ', ${cartState.deliveryTimeSlot}' : ''}"
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                _buildSummaryRow("Total", "${cartState.total.toStringAsFixed(2)} SAR", bold: true),
              ],
            ),
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
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Payment Method",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildPaymentMethodOption(
                "card",
                "Credit/Debit Card",
                "Visa, Mastercard, MADA",
                const Icon(Icons.credit_card_outlined),
              ),
              _buildPaymentMethodOption(
                "apple",
                "Apple Pay",
                "",
                const Icon(Icons.apple),
              ),
              _buildPaymentMethodOption(
                "stc",
                "STC Pay",
                "",
                const Text("STC", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildPaymentMethodOption(
                "cash",
                "Cash on Delivery",
                "",
                const Icon(Icons.money_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
      String value,
      String title,
      String subtitle,
      Widget icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          RadioListTile(
            value: value,
            groupValue: paymentMethod,
            onChanged: (value) {
              setState(() {
                paymentMethod = value.toString();
              });
            },
            title: Row(
              children: [
                icon,
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            secondary: value == "card"
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // You would add payment method icons here
                // Image.asset("assets/visa.png", height: 20),
                SizedBox(width: 8),
                // Image.asset("assets/mastercard.png", height: 20),
              ],
            )
                : null,
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildOrderConfirmationDialog(CartState cartState) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 20),
            const Text(
              "Order Confirmed!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Order #$orderId",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pickup Time"),
                Text(
                  "${DateFormat('MMM d').format(cartState.pickupDate)}${cartState.pickupTimeSlot != null ? ', ${cartState.pickupTimeSlot}' : ''}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Delivery Time"),
                Text(
                  "${DateFormat('MMM d').format(cartState.deliveryDate)}${cartState.deliveryTimeSlot != null ? ', ${cartState.deliveryTimeSlot}' : ''}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showOrderConfirmation = false;
                });
                ref.read(cartProvider.notifier).clearCart();
                context.go('/orders');
              },
              child: const Text("View Orders"),
            ),
          ],
        ),
      ),
    );
  }
}