import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  const Failure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

// يمكنك إضافة أنواع أخرى من الأخطاء هنا مثل CacheFailure, NetworkFailure, إلخ.
