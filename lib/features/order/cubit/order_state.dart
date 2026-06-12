import 'package:equatable/equatable.dart';

enum OrderStatus { loading, success, failure }

class OrderItem {
  final String id;
  final String date;
  final double total;
  final String status; // Processing, Delivered, Cancelled
  final int itemsCount;

  OrderItem({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.itemsCount,
  });
}

class OrderHistoryState extends Equatable {
  final OrderStatus status;
  final List<OrderItem> orders;
  final String? errorMessage;

  const OrderHistoryState({
    this.status = OrderStatus.loading,
    this.orders = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, orders, errorMessage];
}
