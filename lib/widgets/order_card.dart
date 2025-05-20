import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order_model.dart';
import '../providers/orders_provider.dart';
import 'custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderCard extends ConsumerWidget {
  final Order order;
  final VoidCallback onTap;
  final bool isUpcoming;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.isUpcoming = false,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'assigned':
        return Colors.green.shade100;
      case 'in_progress':
        return Colors.blue.shade100;
      case 'completed':
        return Colors.grey.shade300;
      default:
        return Colors.grey.shade200;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'assigned':
        return 'Assigned';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Scheduled';
    }
  }

  Color getOrderTypeColor(String type) {
    switch (type) {
      case 'pickup':
        return Colors.orange;
      case 'delivery':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersNotifier = ref.read(ordersProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: isUpcoming ? Colors.grey.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #${order.orderNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${order.itemCount} items • ${order.orderType}',
                        style: TextStyle(color: getOrderTypeColor(order.orderType))),
                  ],
                ),
                Chip(
                  label: Text(isUpcoming ? 'Scheduled' : getStatusText(order.status)),
                  backgroundColor: isUpcoming ? Colors.grey.shade300 : getStatusColor(order.status),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date & Address
            Row(
              children: [
                Icon(
                  isUpcoming ? Icons.access_time : Icons.location_pin,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isUpcoming)
                        Text(DateFormat('EEEE, h:mm a')
                            .format(order.scheduledDate ?? DateTime.now())),
                      Text(order.customerAddress, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            if (!isUpcoming) ...[
              const Divider(height: 24),

              // Customer Info
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(order.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Payment Info
              Row(
                children: [
                  const Icon(Icons.payment, color: Colors.grey),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment: ${order.paymentMethod}'),
                      Text('Amount: ${(order.totalAmount / 100).toStringAsFixed(2)} SAR',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action Buttons
              if (order.status == 'assigned')
                CustomButton(
                  text: 'Start Delivery',
                  // onPressed: () async {
                  //   ordersNotifier.startDelivery(order.id);
                  //   Fluttertoast.showToast(msg: 'Started delivery of order ${order.orderNumber}');
                  //   await openInGoogleMaps();
                  // },
                  onPressed: () {
                    openInGoogleMaps();
                  },
                ),
              if (order.status == 'in_progress')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: onTap,
                      child: const Text('View Route'),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      text: 'Complete',
                      onPressed: () {
                        Navigator.pushNamed(context, '/payment/${order.id}');
                      },
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> openInGoogleMaps() async {
    final Uri geoUri = Uri.parse('geo:24.904277,67.113809?q=24.904277,67.113809(Label)');
    final Uri webUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=24.904277,67.113809',
    );

    debugPrint('Trying geo URI...');
    if (await canLaunchUrl(geoUri)) {
      debugPrint('Launching geo URI...');
      final success = await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      if (!success) debugPrint('launchUrl() failed for geo URI');
    } else {
      debugPrint('Geo URI failed, trying web URL...');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch Google Maps in any mode.');
      }
    }
  }
}
