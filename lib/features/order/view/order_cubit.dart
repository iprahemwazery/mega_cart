import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderHistoryState> {
  OrderCubit() : super(const OrderHistoryState());

  void loadOrders() async {
    emit(const OrderHistoryState(status: OrderStatus.loading));

    // محاكاة تأخير بسيط لجلب البيانات
    await Future.delayed(const Duration(milliseconds: 800));

    // بيانات ثابتة للتصميم
    final dummyOrders = [
      OrderItem(
        id: '#MC-9582',
        date: '17 May 2026',
        total: 125.50,
        status: 'delivered',
        itemsCount: 3,
      ),
      OrderItem(
        id: '#MC-8471',
        date: '08 May 2026',
        total: 85.00,
        status: 'processing',
        itemsCount: 1,
      ),
      OrderItem(
        id: '#MC-7360',
        date: '02 May 2026',
        total: 210.20,
        status: 'cancelled',
        itemsCount: 5,
      ),
      OrderItem(
        id: '#MC-6259',
        date: '02 May 2026',
        total: 45.00,
        status: 'delivered',
        itemsCount: 2,
      ),
    ];

    emit(OrderHistoryState(status: OrderStatus.success, orders: dummyOrders));
  }
}
