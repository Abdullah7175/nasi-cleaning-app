import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/customer_order_model.dart';
import '../providers/customer_orders_provider.dart';

class CustomerOrdersScreen extends ConsumerStatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  ConsumerState<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends ConsumerState<CustomerOrdersScreen> {
  String activeTab = "all";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(customerOrdersProvider.notifier).loadSampleOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(customerOrdersProvider);
    final filteredOrders = activeTab == "all"
        ? orders
        : orders.where((order) => order.status == activeTab).toList();

    final statusColors = {
      "delivered": Colors.green,
      "in_progress": Colors.blue,
      "scheduled": Colors.orange,
      "cancelled": Colors.red,
    };

    final statusLabels = {
      "delivered": "Delivered",
      "in_progress": "In Progress",
      "scheduled": "Scheduled",
      "cancelled": "Cancelled",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton("all", "All"),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTabButton("in_progress", "Active"),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTabButton("delivered", "Completed"),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(order, statusColors, statusLabels);
              },
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildTabButton(String tab, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: activeTab == tab ? Theme.of(context).primaryColor : Colors.grey[200],
        foregroundColor: activeTab == tab ? Colors.white : Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: () {
        setState(() {
          activeTab = tab;
        });
      },
      child: Text(label),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No Orders Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You don't have any ${activeTab != "all" ? activeTab : ""} orders yet.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
      CustomerOrder order,
      Map<String, Color> statusColors,
      Map<String, String> statusLabels,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColors[order.status]!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabels[order.status]!,
                    style: TextStyle(
                      color: statusColors[order.status],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM d, yyyy • h:mm a').format(order.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item.quantity} × ${item.name}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "${(item.price * item.quantity).toStringAsFixed(2)} SAR",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${order.total.toStringAsFixed(2)} SAR",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              order.vendor.name,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              order.vendor.address,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (order.status == "in_progress") ...[
              const SizedBox(height: 16),
              const Text(
                "Order Status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildTrackingProgress(order.trackingInfo),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Estimated delivery: ${order.deliveryTime}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle reorder
                    },
                    child: const Text("Reorder"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle get help
                    },
                    child: const Text("Get Help"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingProgress(TrackingInfo trackingInfo) {
    // Calculate the progress percentage as a double between 0.0 and 1.0
    double progress = trackingInfo.delivered
        ? 1.0
        : trackingInfo.delivery
        ? 0.75
        : trackingInfo.cleaning
        ? 0.5
        : trackingInfo.picked
        ? 0.25
        : 0.0;

    return Column(
      children: [
        Stack(
          children: [
            Divider(
              thickness: 2,
              color: Colors.grey[300],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    height: 2,
                    width: constraints.maxWidth * progress,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTrackingStep(1, "Picked Up", trackingInfo.picked),
            _buildTrackingStep(2, "Cleaning", trackingInfo.cleaning),
            _buildTrackingStep(3, "Delivery", trackingInfo.delivery),
            _buildTrackingStep(4, "Delivered", trackingInfo.delivered),
          ],
        ),
      ],
    );
  }

  Widget _buildTrackingStep(int step, String label, bool completed) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: completed ? Theme.of(context).primaryColor : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: completed
              ? Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          )
              : Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}