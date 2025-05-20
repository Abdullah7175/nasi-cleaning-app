import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order_model.dart';
import '../providers/auth_provider.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ordersProvider.notifier).loadSampleOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final activeOrders = orders.where((o) => o.status == 'assigned' || o.status == 'in_progress').toList();
    final upcomingOrders = orders.where((o) => o.scheduledDate != null && o.scheduledDate!.isAfter(DateTime.now())).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // App Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Orders",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.notifications_none, color: Colors.grey[600]),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${orders.length} Orders",
                        style: TextStyle(
                          color: Colors.green[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Order List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  if (activeOrders.isNotEmpty) ...[
                    Text(
                      "ACTIVE DELIVERIES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...activeOrders.map((order) => _buildOrderCard(order, context)),
                  ],

                  if (upcomingOrders.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      "UPCOMING DELIVERIES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...upcomingOrders.map((order) => _buildOrderCard(order, context, isUpcoming: true)),
                  ],

                  if (activeOrders.isEmpty && upcomingOrders.isEmpty) ...[
                    const SizedBox(height: 48),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.assignment, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "No orders assigned",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Check back later for new orders",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, BuildContext context, {bool isUpcoming = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Handle order tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order #${order.id}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUpcoming ? Colors.orange[50] : Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isUpcoming ? "Upcoming" : "Active",
                      style: TextStyle(
                        color: isUpcoming ? Colors.orange[500] : Colors.green[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                order.customerName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.customerAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SAR ${order.totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onPressed: () {
                      if (isUpcoming) {
                        _showOrderDetails(order);
                      } else {
                        _startDelivery(order);
                      }
                    },
                    child: Text(
                      isUpcoming ? "Details" : "Start Delivery",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Order #${order.id} Details",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow("Customer", order.customerName),
              _buildDetailRow("Address", order.customerAddress),
              _buildDetailRow("Scheduled", DateFormat('MMM d, yyyy - hh:mm a').format(order.scheduledDate!)),
              _buildDetailRow("Payment", order.paymentMethod == 'cash' ? "Cash on Delivery" : "Paid Online"),
              _buildDetailRow("Items", "20"),
              _buildDetailRow("Amount", "SAR ${order.totalAmount.toStringAsFixed(2)}"),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startDelivery(Order order) {
    // Show confirmation dialog before starting delivery
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Start Delivery"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Order #${order.id}"),
            const SizedBox(height: 8),
            Text(order.customerAddress),
            const SizedBox(height: 16),
            const Text("Are you ready to start this delivery?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[500],
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              // Update order status
              ref.read(ordersProvider.notifier).startDelivery(order.id);
              // Open in maps
              await _openOrderInMaps(order);
            },
            child: const Text("Start Delivery"),
          ),
        ],
      ),
    );
  }

  Future<void> _openOrderInMaps(Order order) async {
    // Try native maps first
    final String geoUri = 'geo:${order.latitude},${order.longitude}?q=${Uri.encodeComponent(order.customerAddress)}';

    // Fallback to Google Maps web URL
    final String webUri = 'https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longitude}(${Uri.encodeComponent(order.customerAddress)})';

    // Try to launch the geo URI
    try {
      if (await canLaunchUrl(Uri.parse(geoUri))) {
        await launchUrl(
          Uri.parse(geoUri),
          mode: LaunchMode.externalApplication,
        );
        return;
      }
    } catch (e) {
      debugPrint('Error launching geo URI: $e');
    }

    // If geo URI fails, try web URL
    try {
      if (await canLaunchUrl(Uri.parse(webUri))) {
        await launchUrl(
          Uri.parse(webUri),
          mode: LaunchMode.externalApplication,
        );
        return;
      }
    } catch (e) {
      debugPrint('Error launching web URL: $e');
    }

    // If all else fails, show instructions
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Navigation Not Available"),
        content: const Text("Could not launch maps application. Please install Google Maps or another navigation app."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}