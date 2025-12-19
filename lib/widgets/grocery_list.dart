import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadGroceryItems();
  }

  void _loadGroceryItems() async {
    final url = Uri.https(
      'itec315shoppinglist-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    final response = await http.get(url);
    final Map<String, dynamic>? listData = json.decode(response.body);
    if (listData == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere( // function that finds the first element that matches the condition, here, we are using this to find the category that matches the category name stored in the database and assigning it to the grocery item so that we can use its color property later
              (catItem) => catItem.value.name == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      isLoading = false;
    });
  }

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
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
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
