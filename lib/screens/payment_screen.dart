import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/order_model.dart';
import '../providers/orders_provider.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final int orderId;
  const PaymentPage({Key? key, required this.orderId}) : super(key: key);

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  String paymentMethod = 'cash';
  String notes = '';
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final order = orders.firstWhere(
          (o) => o.id == widget.orderId,
      orElse: () => throw Exception('Order not found'), // Throw an error if order is not found
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Order ID', '#${order.orderNumber}'),
                    _buildDetailRow('Items', '${order.itemCount}'),
                    _buildDetailRow(
                      'Customer',
                      '${order.customerName.split(" ")[0]} ${order.customerName.split(" ")[1][0]}.',
                    ),
                    _buildDetailRow(
                      'Total Amount',
                      '${(order.totalAmount / 100).toStringAsFixed(2)} SAR',
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildRadioTile('cash', 'Cash', 'Cash on delivery'),
            _buildRadioTile('card', 'Card Machine', 'Customer pays by card'),
            _buildRadioTile('online', 'Already Paid Online', 'Pre-paid order'),
            const SizedBox(height: 16),
            const Text(
              'Notes (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Add any payment related notes here',
              ),
              onChanged: (val) => setState(() => notes = val),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSubmitting ? null : () async => await _submitPayment(order),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(50),
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm Payment & Complete Delivery'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String value, String title, String subtitle) {
    return RadioListTile<String>(
      value: value,
      groupValue: paymentMethod,
      onChanged: (val) => setState(() => paymentMethod = val!),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Future<void> _submitPayment(Order order) async {
    setState(() => isSubmitting = true);
    try {
      // Use ref.read to access the provider directly
      final provider = ref.read(ordersProvider.notifier);

      // Update payment for the order
      await provider.updatePayment(order.id, {
        'paymentMethod': paymentMethod,
        'paymentStatus': 'completed',
        if (notes.isNotEmpty) 'notes': notes,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment confirmed. Delivery completed.')),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed. Please try again.'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }
}
