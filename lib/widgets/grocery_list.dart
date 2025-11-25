import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const NewItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: const Text('Your Groceries'),
      actions: [
        IconButton(
          onPressed: _addItem,
          icon: Icon(Icons.add_box))
      ],
      ),      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, idx) => ListTile(
          title: Text(groceryItems[idx].name),
          leading: Container(
            width: 24, 
            height: 24,
            color: groceryItems[idx].category.color,
          ),
          trailing: Text(groceryItems[idx].quantity.toString()),
        )
      )
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
