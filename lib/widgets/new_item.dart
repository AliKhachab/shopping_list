import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
//import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'dart:convert'; // for json encoding
import 'package:http/http.dart' as http; // for making http requests

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

@override
class _NewItemState extends State<NewItem> {
  final _formKey =
      GlobalKey<
        FormState
      >(); // instead of using controllers, we use a form key to manage form state
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;
  void _saveItem() async {
    setState(() {
      _isSending = true;
    });
    // take the form, check the state, and check if any fields are invalid. we need to put ! b/c what if state is null? in our case it won't ever be null because the form will always be there when this method is called
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
        'itec315shoppinglist-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.name,
        }),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(
        GroceryItem(
          id: responseData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory,
        ),
      );
    }
  }

  // void _showDialog(String message) {
  //   showPlatformDialog(
  //     context: context,
  //     builder: (ctx) => PlatformAlertDialog(
  //       title: const Text('Invalid Input'),
  //       content: Text(message),
  //       actions: [
  //         PlatformDialogAction(
  //           child: const Text('Okay'),
  //           onPressed: () {
  //             Navigator.of(ctx).pop();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new item")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.trim().length > 50) {
                    return 'Please enter a name up to 50 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text("Quantity")),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Please enter a valid positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                      initialValue: '1',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      initialValue: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.name),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedCategory = value!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            };
                    },
                    child: Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text("Add Item"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
