// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import '../providers/cart_provider.dart';
//
// class VendorsScreen extends ConsumerWidget {
//   const VendorsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final vendors = [
//       {
//         'id': 1,
//         'name': 'NASI Cleaning Services',
//         'description': 'Premium laundry and dry cleaning services',
//         'image': 'lib/assets/logo.png',
//         'address': "makkah street, Al otaibya",
//         'city': "Makkah",
//         'latitude': 24.7136,
//         'longitude': 46.6753,
//         'rating': 4.8,
//         'isOpen': true,
//         'distance': 3.5,
//       },
//       {
//         'id': 2,
//         'name': "Arbi Cleaning",
//         'description': "Premium laundry and dry cleaning services",
//         'imageUrl': "https://images.unsplash.com/photo-1582735689369-4fe89db7114c?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
//         'address': "123 Abdullah Street, Al Olaya",
//         'city': "Riyadh",
//         'latitude': 24.7136,
//         'longitude': 46.6753,
//         'rating': 4.8,
//         'isOpen': true,
//         'distance': 3.5,
//       },
//       {
//         'id': 3,
//         'name': "Sparkle Clean Laundry",
//         'description': "Eco-friendly bedding specialists",
//         'imageUrl': "https://images.unsplash.com/photo-1620574387735-3624d75b2dbc?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
//         'address': "45 King Fahd Road, Al Malaz",
//         'city': "Riyadh",
//         'latitude': 24.6913,
//         'longitude': 46.7212,
//         'rating': 4.6,
//         'reviewCount': 89,
//         'isOpen': true,
//         'distance': 3.5,
//       },
//       {
//         'id': 4,
//         'name': "Royal Linens Care",
//         'description': "Luxury bedding & linen cleaning",
//         'imageUrl': "https://images.unsplash.com/photo-1600585152220-90363fe7e115?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
//         'address': "78 Tahlia Street, Al Sulaimaniyah",
//         'city': "Riyadh",
//         'latitude': 24.7028,
//         'longitude': 46.6601,
//         'rating': 4.9,
//         'reviewCount': 156,
//         'isOpen': true,
//         'distance': 2.8,
//       },
//       {
//         'id': 5,
//         'name': "Fresh Fabric Laundry",
//         'description': "Specialized in delicate fabrics",
//         'imageUrl': "https://images.unsplash.com/photo-1604335399105-a0c585fd81a1?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
//         'address': "12 Prince Mohammed Bin Abdulaziz Rd, Al Nahda",
//         'city': "Riyadh",
//         'latitude': 24.7563,
//         'longitude': 46.6840,
//         'rating': 4.5,
//         'reviewCount': 72,
//         'isOpen': true,
//         'distance': 4.1,
//       },
//       {
//         'id': 6,
//         'name': "Bedding Experts",
//         'description': "Specialized in all bedding items",
//         'imageUrl': "https://images.unsplash.com/photo-1555117041-5379961b584b?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
//         'address': "56 Mecca Road, Al Wizarat",
//         'city': "Riyadh",
//         'latitude': 24.6890,
//         'longitude': 46.7103,
//         'rating': 4.7,
//         'reviewCount': 104,
//         'isOpen': true,
//         'distance': 3.7,
//       }
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nearby Laundry Services'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.go('/home'),
//         ),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: vendors.length,
//         itemBuilder: (context, index) {
//           final vendor = vendors[index];
//           final imageSource = (vendor['image'] ?? vendor['imageUrl']) as String;
//           final distanceText = vendor['distance'] is double
//               ? '${vendor['distance']} km'
//               : vendor['distance'].toString();
//
//           return GestureDetector(
//             onTap: () {
//               // Initialize cart
//               ref.read(cartProvider.notifier).initializeWithVendor(
//                 vendor['id'].toString(),
//                 vendor['name'] as String,
//                 imageSource.toString(),
//                 distanceText,
//               );
//
//               // Navigate to services page for that vendor
//               context.go('/home/vendors/${vendor['id']}/services');
//             },
//             child: Card(
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Container(
//                         width: 80,
//                         height: 80,
//                         color: Colors.grey[200],
//                         child: imageSource != null
//                             ? imageSource.toString().startsWith('http')
//                             ? Image.network(
//                           imageSource,
//                           width: 80,
//                           height: 80,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                           const Icon(Icons.broken_image),
//                         )
//                             : Image.asset(
//                           imageSource,
//                           width: 80,
//                           height: 80,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                           const Icon(Icons.broken_image),
//                         )
//                             : const Icon(Icons.image),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             vendor['name'] as String,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             vendor['description'] as String,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               const Icon(Icons.star, color: Colors.amber, size: 16),
//                               Text(' ${vendor['rating']}'),
//                               const SizedBox(width: 16),
//                               const Icon(Icons.location_on, size: 16),
//                               Text(' $distanceText'),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${vendor['address']}, ${vendor['city']}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../providers/cart_provider.dart';

class VendorsScreen extends ConsumerStatefulWidget {
  const VendorsScreen({super.key});

  @override
  ConsumerState<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends ConsumerState<VendorsScreen> {
  late final List<Map<String, dynamic>> vendors;
  LatLng? _currentLocation;
  LatLngBounds? _mapBounds;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    vendors = _initializeVendors();
    _currentLocation = const LatLng(24.7136, 46.6753); // Default location (Riyadh)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _calculateMapBounds();
      }
    });
  }

  void _calculateMapBounds() {
    final List<LatLng> points = [
      _currentLocation!,
      ...vendors.map((v) => LatLng(v['latitude'], v['longitude']))
    ];

    double? minLat, maxLat, minLng, maxLng;
    for (final point in points) {
      minLat = minLat == null ? point.latitude : (point.latitude < minLat ? point.latitude : minLat);
      maxLat = maxLat == null ? point.latitude : (point.latitude > maxLat ? point.latitude : maxLat);
      minLng = minLng == null ? point.longitude : (point.longitude < minLng ? point.longitude : minLng);
      maxLng = maxLng == null ? point.longitude : (point.longitude > maxLng ? point.longitude : maxLng);
    }

    if (mounted) {
      setState(() {
        _mapBounds = LatLngBounds(
          LatLng(minLat!, minLng!),
          LatLng(maxLat!, maxLng!),
        );
      });
    }

    // Fit bounds after a small delay to allow map to initialize
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mapBounds != null && mounted) {
        _mapController.fitBounds(
          _mapBounds!,
          options: const FitBoundsOptions(padding: EdgeInsets.all(50)),
        );
      }
    });
  }

  List<Map<String, dynamic>> _initializeVendors() {
    return [
      {
        'id': 1,
        'name': 'NASI Cleaning Services',
        'description': 'Premium laundry and dry cleaning services',
        'image': 'lib/assets/logo.png',
        'address': "Makkah Street, Al Otaibya",
        'city': "Makkah",
        'latitude': 24.7136,
        'longitude': 46.6753,
        'rating': 4.8,
        'isOpen': true,
        'distance': 3.5,
      },
      {
        'id': 2,
        'name': "Arbi Cleaning",
        'description': "Premium laundry and dry cleaning services",
        'imageUrl': "https://images.unsplash.com/photo-1582735689369-4fe89db7114c?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
        'address': "123 Abdullah Street, Al Olaya",
        'city': "Riyadh",
        'latitude': 24.7136,
        'longitude': 46.6753,
        'rating': 4.8,
        'isOpen': true,
        'distance': 3.5,
      },
      {
        'id': 3,
        'name': "Sparkle Clean Laundry",
        'description': "Eco-friendly bedding specialists",
        'imageUrl': "https://images.unsplash.com/photo-1620574387735-3624d75b2dbc?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
        'address': "45 King Fahd Road, Al Malaz",
        'city': "Riyadh",
        'latitude': 24.6913,
        'longitude': 46.7212,
        'rating': 4.6,
        'reviewCount': 89,
        'isOpen': true,
        'distance': 3.5,
      },
      {
        'id': 4,
        'name': "Royal Linens Care",
        'description': "Luxury bedding & linen cleaning",
        'imageUrl': "https://images.unsplash.com/photo-1600585152220-90363fe7e115?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
        'address': "78 Tahlia Street, Al Sulaimaniyah",
        'city': "Riyadh",
        'latitude': 24.7028,
        'longitude': 46.6601,
        'rating': 4.9,
        'reviewCount': 156,
        'isOpen': true,
        'distance': 2.8,
      },
      {
        'id': 5,
        'name': "Fresh Fabric Laundry",
        'description': "Specialized in delicate fabrics",
        'imageUrl': "https://images.unsplash.com/photo-1604335399105-a0c585fd81a1?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
        'address': "12 Prince Mohammed Bin Abdulaziz Rd, Al Nahda",
        'city': "Riyadh",
        'latitude': 24.7563,
        'longitude': 46.6840,
        'rating': 4.5,
        'reviewCount': 72,
        'isOpen': true,
        'distance': 4.1,
      },
      {
        'id': 6,
        'name': "Bedding Experts",
        'description': "Specialized in all bedding items",
        'imageUrl': "https://images.unsplash.com/photo-1555117041-5379961b584b?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150&q=80",
        'address': "56 Mecca Road, Al Wizarat",
        'city': "Riyadh",
        'latitude': 24.6890,
        'longitude': 46.7103,
        'rating': 4.7,
        'reviewCount': 104,
        'isOpen': true,
        'distance': 3.7,
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Laundry Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Map Section
          SizedBox(
            height: 250,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation,
                zoom: 12.0,
                minZoom: 5.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (_currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation!,
                        builder: (ctx) => const Icon(Icons.location_on, color: Colors.blue, size: 40),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: vendors.map((vendor) {
                    return Marker(
                      point: LatLng(vendor['latitude'], vendor['longitude']),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          _mapController.move(
                            LatLng(vendor['latitude'], vendor['longitude']),
                            _mapController.zoom,
                          );
                        },
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Vendor List Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                final vendor = vendors[index];
                final imageSource = (vendor['image'] ?? vendor['imageUrl']) as String;
                final distanceText = vendor['distance'] is double
                    ? '${vendor['distance']} km'
                    : vendor['distance'].toString();

                return GestureDetector(
                  onTap: () {
                    ref.read(cartProvider.notifier).initializeWithVendor(
                      vendor['id'].toString(),
                      vendor['name'] as String,
                      imageSource.toString(),
                      distanceText,
                    );
                    context.go('/home/vendors/${vendor['id']}/services');
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vendor Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageSource,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 80),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Vendor Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vendor['name'] as String,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  vendor['description'] as String,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber[700], size: 16),
                                    const SizedBox(width: 4),
                                    Text('${vendor['rating']}', style: const TextStyle(fontSize: 13)),
                                    const Spacer(),
                                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text(distanceText, style: const TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
