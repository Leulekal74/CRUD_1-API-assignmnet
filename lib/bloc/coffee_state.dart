import '../data/models/coffee_order.dart';

abstract class CoffeeState {}

class CoffeeInitial extends CoffeeState {}
class CoffeeLoading extends CoffeeState {}
class CoffeeLoaded extends CoffeeState {
  final List<CoffeeOrder> orders;
  CoffeeLoaded(this.orders);
}
class CoffeeError extends CoffeeState {
  final String message;
  CoffeeError(this.message);
}