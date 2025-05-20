// services_screen.dart
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/cart_provider.dart';

class ServicesScreen extends ConsumerWidget {
  final String vendorId;

  const ServicesScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This would normally come from your backend or provider
    final services = [
      {
        'id': '1',
        'name': 'Bedsheets',
        'serviceType': 'Wash & Iron',
        'price': 15.0,
      },
      {
        'id': '2',
        'name': 'Pillows',
        'serviceType': 'Wash & Dry',
        'price': 10.0,
      },
      // Add more services as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Services'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(service['serviceType'] as String),
                  const SizedBox(height: 8),
                  Text(
                    '${service['price']} SAR',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addItem(
                        CartItem(
                          id: service['id'] as String,
                          name: service['name'] as String,
                          serviceType: service['serviceType'] as String,
                          price: service['price'] as double,
                          quantity: 1,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${service['name']} added to cart')),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}