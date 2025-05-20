import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Correct import
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final int orderId;
  final String customerName;
  final String customerAddress;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final double totalAmount;
  final String paymentMethod;
  final int itemCount;
  final List<Map<String, dynamic>> items;

  const MapScreen({
    Key? key,
    required this.orderId,
    required this.customerName,
    required this.customerAddress,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.totalAmount,
    required this.paymentMethod,
    required this.itemCount,
    required this.items,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isUpdating = false;
  final MapController _mapController = MapController();

  Future<void> handleCallCustomer() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: widget.phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Could not launch $phoneUri');
    }
  }

  void handleCompleteDelivery() {
    setState(() {
      isUpdating = true;
    });

    // Simulate updating order status
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isUpdating = false;
      });
      // Navigate to payment screen (implement navigation logic here)
      Navigator.pushNamed(context, '/payment/${widget.orderId}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Container
          Container(
            height: 250,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(widget.latitude, widget.longitude),
                zoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  tileProvider: NetworkTileProvider(), // Default tile provider
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(widget.latitude, widget.longitude),
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Order Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Name: ${widget.customerName}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('Delivery Address: ${widget.customerAddress}'),
                    SizedBox(height: 10),
                    Text('Order Details:'),
                    Text('• ${widget.itemCount} items'),
                    ...widget.items.map(
                          (item) => Text('• ${item['quantity']}× ${item['name']}'),
                    ),
                    Divider(),
                    Text('Payment Method: ${widget.paymentMethod}'),
                    Text(
                        'Total Amount: ${(widget.totalAmount / 100).toStringAsFixed(2)} SAR'),
                    SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: handleCallCustomer,
                        ),
                        ElevatedButton(
                          onPressed: handleCompleteDelivery,
                          child: isUpdating
                              ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : Text('Mark as Delivered'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
