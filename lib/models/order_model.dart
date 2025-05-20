class Order {
  final int id;
  final String orderNumber;
  final String status;
  final String customerName;
  final String customerAddress;
  final double latitude;  // Add this
  final double longitude; // Add this
  final String customerPhone;
  final double totalAmount;
  final int itemCount;
  final String orderType;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime? scheduledDate;
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<Map<String, dynamic>> items;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.customerName,
    required this.customerAddress,
    required this.latitude,
    required this.longitude,
    required this.customerPhone,
    required this.totalAmount,
    required this.itemCount,
    required this.orderType,
    required this.paymentMethod,
    required this.paymentStatus,
    this.scheduledDate,
    required this.createdAt,
    this.completedAt,
    required this.items,
  });

  // CopyWith method to create a new instance with updated fields
  Order copyWith({
    String? orderNumber,
    String? status,
    String? customerName,
    String? customerAddress,
    double? latitude,
    double? longitude,
    String? customerPhone,
    double? totalAmount,
    int? itemCount,
    String? orderType,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? scheduledDate,
    DateTime? createdAt,
    DateTime? completedAt,
    List<Map<String, dynamic>>? items,
  }) {
    return Order(
      id: this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      customerPhone: customerPhone ?? this.customerPhone,
      totalAmount: totalAmount ?? this.totalAmount,
      itemCount: itemCount ?? this.itemCount,
      orderType: orderType ?? this.orderType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      items: items ?? this.items,
    );
  }
}
