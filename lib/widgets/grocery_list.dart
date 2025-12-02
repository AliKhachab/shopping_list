import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));
    if (newItem == null) {
      return;
    } else {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _removeItem(String id) {
    int groceryIdx = _groceryItems.indexWhere((item) => item.id == id);
    final removedItem = _groceryItems[groceryIdx];
    setState(() {
      _groceryItems.removeAt(groceryIdx);
    });
        ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Grocery item deleted."),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _groceryItems.add(removedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("You have no groceries. Press the + button to add some."));
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, idx) => Dismissible(
          key: ValueKey(_groceryItems[idx].id),
          onDismissed: (direction) => _removeItem(_groceryItems[idx].id),
          child: ListTile(
            title: Text(_groceryItems[idx].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[idx].category.color,
            ),
            trailing: Text(_groceryItems[idx].quantity.toString()),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add_box))],
      ),
      body: content,
    );

  }
}

/* 
itemBuilder: (ctx, idx) => Dismissible(
          onDismissed: (direction) {
            onRemoveGrocery(groceryItems[idx].id)
          },
          key: ValueKey(groceryItems[idx]),
          background: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16
            ),
            color: Theme.of(context).colorScheme.error.withValues(alpha: .75),
          ),
          child: ListTile(
            title: Text(groceryItems[idx].name),
            leading: CircleAvatar(
              backgroundColor: groceryItems[idx].category.color,
              child: Text(
                groceryItems[idx].quantity.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ),
*/
