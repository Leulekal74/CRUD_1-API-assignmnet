import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crud_1/bloc/coffee_bloc.dart';
import 'package:crud_1/bloc/coffee_event.dart';
import 'package:crud_1/bloc/coffee_state.dart';
import 'package:crud_1/data/models/coffee_order.dart';
import 'order_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ CafeConnect Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4A2C11),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<CoffeeBloc>().add(LoadOrdersEvent()),
          )
        ],
      ),
      body: BlocConsumer<CoffeeBloc, CoffeeState>(
        listener: (context, state) {
          if (state is CoffeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is CoffeeLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4A2C11)));
          } else if (state is CoffeeLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No active cafe orders found.', style: TextStyle(fontSize: 16)));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF8B5A2B),
                      child: Icon(Icons.coffee, color: Colors.white),
                    ),
                    title: Text(order.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(order.body, style: TextStyle(color: Colors.grey[700])),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OrderFormScreen(existingOrder: order)),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (order.id != null) {
                              context.read<CoffeeBloc>().add(RemoveOrderEvent(order.id!));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Pull to refresh.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A2C11),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrderFormScreen()),
        ),
      ),
    );
  }
}