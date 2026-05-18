import '../data/models/coffee_order.dart';

abstract class CoffeeEvent {}

class LoadOrdersEvent extends CoffeeEvent {}

class AddOrderEvent extends CoffeeEvent {
  final CoffeeOrder order;
  AddOrderEvent(this.order);
}

class EditOrderEvent extends CoffeeEvent {
  final int id;
  final CoffeeOrder updatedOrder;
  EditOrderEvent(this.id, this.updatedOrder);
}

class RemoveOrderEvent extends CoffeeEvent {
  final int id;
  RemoveOrderEvent(this.id);
}