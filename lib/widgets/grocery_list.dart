import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grocery List')),
      body: ListView.builder(
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
