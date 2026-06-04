import 'package:equatable/equatable.dart';

enum CheckoutStatus { initial, loading, success, failure }

enum CardType { unknown, visa, mastercard, amex, discover }

class CheckoutState extends Equatable {
  final String address;
  final String cardNumber;
  final String couponCode;
  final CheckoutStatus status;
  final String? errorMessage;
  final CardType cardType;

  const CheckoutState({
    this.address = '',
    this.cardNumber = '',
    this.couponCode = '',
    this.status = CheckoutStatus.initial,
    this.errorMessage,
    this.cardType = CardType.unknown,
  });

  CheckoutState copyWith({
    String? address,
    String? cardNumber,
    String? couponCode,
    CheckoutStatus? status,
    String? errorMessage,
    CardType? cardType,
  }) {
    return CheckoutState(
      address: address ?? this.address,
      cardNumber: cardNumber ?? this.cardNumber,
      couponCode: couponCode ?? this.couponCode,
      status: status ?? this.status,
      errorMessage: errorMessage,
      cardType: cardType ?? this.cardType,
    );
  }

  @override
  List<Object?> get props => [
    address,
    cardNumber,
    couponCode,
    status,
    errorMessage,
    cardType,
  ];
}
