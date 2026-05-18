import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crud_1/bloc/coffee_bloc.dart';
import 'package:crud_1/bloc/coffee_event.dart';
import 'package:crud_1/data/models/coffee_order.dart';

class OrderFormScreen extends StatefulWidget {
  final CoffeeOrder? existingOrder;
  const OrderFormScreen({Key? key, this.existingOrder}) : super(key: key);

  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingOrder?.title ?? '');
    _bodyController = TextEditingController(text: widget.existingOrder?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final order = CoffeeOrder(
        id: widget.existingOrder?.id,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      if (widget.existingOrder == null) {
        context.read<CoffeeBloc>().add(AddOrderEvent(order));
      } else {
        context.read<CoffeeBloc>().add(EditOrderEvent(widget.existingOrder!.id!, order));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingOrder != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modify Coffee Item' : 'New Menu Registration', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4A2C11),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Menu Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please input item title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Recipe Specifications',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Specifications are mandatory' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C11),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _submitData,
                child: Text(
                  isEditing ? 'Update Item Entry' : 'Save New Entry',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}