import 'package:flutter_bloc/flutter_bloc.dart';
import 'coffee_event.dart';
import 'coffee_state.dart';
import 'package:crud_1/data/services/api_service.dart';
import 'package:crud_1/data/models/coffee_order.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  final ApiService apiService;
  List<CoffeeOrder> _cachedOrders = [];

  CoffeeBloc(this.apiService) : super(CoffeeInitial()) {
    on<LoadOrdersEvent>((event, emit) async {
      emit(CoffeeLoading());
      try {
        _cachedOrders = await apiService.fetchOrders();
        emit(CoffeeLoaded(List.from(_cachedOrders)));
      } catch (e) {
        emit(CoffeeError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AddOrderEvent>((event, emit) async {
      emit(CoffeeLoading());
      try {
        final newOrder = await apiService.createOrder(event.order);
        _cachedOrders.insert(0, newOrder);
        emit(CoffeeLoaded(List.from(_cachedOrders)));
      } catch (e) {
        emit(CoffeeError(e.toString()));
      }
    });

    on<EditOrderEvent>((event, emit) async {
      emit(CoffeeLoading());
      try {
        final updated = await apiService.updateOrder(event.id, event.updatedOrder);
        final index = _cachedOrders.indexWhere((element) => element.id == event.id);
        if (index != -1) {
          _cachedOrders[index] = updated;
        }
        emit(CoffeeLoaded(List.from(_cachedOrders)));
      } catch (e) {
        emit(CoffeeError(e.toString()));
      }
    });

    on<RemoveOrderEvent>((event, emit) async {
      emit(CoffeeLoading());
      try {
        await apiService.deleteOrder(event.id);
        _cachedOrders.removeWhere((element) => element.id == event.id);
        emit(CoffeeLoaded(List.from(_cachedOrders)));
      } catch (e) {
        emit(CoffeeError(e.toString()));
      }
    });
  }
}