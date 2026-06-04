import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_cart/core/NetWork/order_controller.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final OrderController _orderController;

  CheckoutCubit(this._orderController) : super(const CheckoutState());

  void onAddressChanged(String value) => emit(state.copyWith(address: value));
  void onCardChanged(String value) {
    final cleanedCardNumber = value.replaceAll(RegExp(r'[\s-]'), '');
    final cardType = _getCardType(cleanedCardNumber);
    emit(state.copyWith(cardNumber: value, cardType: cardType));
  }

  void onCouponChanged(String value) => emit(state.copyWith(couponCode: value));

  Future<void> performCheckout() async {
    if (state.address.trim().isEmpty) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'addressRequired',
        ),
      );
      return;
    }

    // فقط تحقق من رقم البطاقة إذا تم إدخاله
    if (state.cardNumber.isNotEmpty) {
      final cleanedCardNumber = state.cardNumber.replaceAll(
        RegExp(r'[\s-]'),
        '',
      );

      if (!_isNumeric(cleanedCardNumber)) {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: 'invalidCardNumberFormat',
          ),
        );
        return;
      }

      final cardType = _getCardType(cleanedCardNumber);
      if (cardType == CardType.unknown) {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: 'unsupportedCardType',
          ),
        );
        return;
      }

      if (!_isValidCardLength(cleanedCardNumber, cardType)) {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: 'invalidCardNumberLength',
          ),
        );
        return;
      }

      if (!_isValidLuhn(cleanedCardNumber)) {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: 'invalidCardNumberLuhn',
          ),
        );
        return;
      }
    }

    final token = await SessionManager.getToken();
    if (token == null || token.isEmpty) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'loginRequiredForCheckout',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.loading));

    try {
      final response = await _orderController.checkout(
        shippingAddressId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        paymentMethod: state.cardNumber.isNotEmpty ? "Card" : "Cash",
        token: token,
      );

      if (response != null) {
        emit(state.copyWith(status: CheckoutStatus.success));
      } else {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: 'errorOccurred',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void clearStatus() => emit(state.copyWith(status: CheckoutStatus.initial));

  bool _isNumeric(String s) {
    if (s.isEmpty) return false;
    return double.tryParse(s) != null;
  }

  bool _isValidLuhn(String cardNumber) {
    if (cardNumber.isEmpty) return false;
    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n = (n % 10) + 1;
      }
      sum += n;
      alternate = !alternate;
    }
    return (sum % 10 == 0);
  }

  CardType _getCardType(String cardNumber) {
    if (cardNumber.isEmpty) return CardType.unknown;
    if (cardNumber.startsWith('4')) return CardType.visa;
    if (cardNumber.startsWith(RegExp(r'5[1-5]')) ||
        cardNumber.startsWith(
          RegExp(r'222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[0-1][0-9]|2720'),
        )) {
      return CardType.mastercard;
    }
    if (cardNumber.startsWith(RegExp(r'34|37'))) return CardType.amex;
    if (cardNumber.startsWith('6011') ||
        cardNumber.startsWith(RegExp(r'64[4-9]')) ||
        cardNumber.startsWith('65')) {
      return CardType.discover;
    }
    return CardType.unknown;
  }

  bool _isValidCardLength(String cardNumber, CardType type) {
    switch (type) {
      case CardType.visa:
        return cardNumber.length == 13 || cardNumber.length == 16;
      case CardType.mastercard:
        return cardNumber.length == 16;
      case CardType.amex:
        return cardNumber.length == 15;
      case CardType.discover:
        return cardNumber.length == 16 || cardNumber.length == 19;
      case CardType.unknown:
        return false;
    }
  }
}
