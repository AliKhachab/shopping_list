import 'package:flutter/material.dart';
import 'package:shopping_list/models/category.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  void _showDialog(String message) {
    showPlatformDialog(
      context: context,
      builder: (ctx) => PlatformAlertDialog(
        title: const Text('Invalid Input'),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: const Center(
        child: Text('Form goes here'),
      ),
    );
  }
}