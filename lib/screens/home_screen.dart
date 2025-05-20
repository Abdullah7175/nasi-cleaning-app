import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentOrders = [
      {
        'id': 1001,
        'status': 'delivered',
        'vendor': 'NASI Cleaning Services',
        'createdAt': DateTime.now().toString(),
        'totalAmount': 75.50
      },
      {
        'id': 1002,
        'status': 'processing',
        'vendor': 'NASI Cleaning Services',
        'createdAt': DateTime.now().subtract(const Duration(days: 7)).toString(),
        'totalAmount': 120.25
      },
    ];

    final services = [
      {'title': 'Bedsheets', 'icon': Icons.bed},
      {'title': 'Pillows', 'icon': Icons.bedroom_child},
      {'title': 'Linen', 'icon': Icons.cleaning_services},
      {'title': 'Curtains', 'icon': Icons.window},
      {'title': 'Duvets', 'icon': Icons.hotel},
      {'title': 'Blankets', 'icon': Icons.bedroom_baby},
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            GestureDetector(
              onTap: () => context.go('/vendors'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text("Search services...", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Promo Banner
            GestureDetector(
              onTap: () => context.go('/vendors'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "20% OFF First Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("Use code WELCOME20", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Our Services
            const Text("Our Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140, // max width of each card
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (_, index) {
                final service = services[index];
                return GestureDetector(
                  onTap: () {
                    context.go('/home/vendors');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(service['icon'] as IconData, size: 36, color: Colors.blueAccent),
                        const SizedBox(height: 8),
                        Text(
                          service['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Recent Orders Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Orders", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(
                  onPressed: () => context.go('/customer-orders'),
                  child: const Text("View All"),
                ),
              ],
            ),

            if (recentOrders.isNotEmpty)
              Column(
                children: recentOrders.map((order) => _buildOrderCard(context, order)).toList(),
              )
            else
              Column(
                children: [
                  const Text("No recent orders", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.go('/home/vendors'),
                    child: const Text("Place Your First Order"),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    Color statusColor;
    switch (order['status']) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'delivered':
        statusColor = Colors.blue;
        break;
      case 'processing':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text("#${order['id'].toString().padLeft(4, '0')}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order['vendor']),
            Text(order['createdAt'].toString().substring(0, 10),
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${order['totalAmount']} SAR", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => context.go('/orders/${order['id']}'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    textStyle: const TextStyle(fontSize: 12),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text("Reorder"),
                ),
              ),
            ],
          ),
        ),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
