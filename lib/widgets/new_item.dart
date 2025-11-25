import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

  @override
  class _NewItemState extends State<NewItem>{
    
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
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new item"),
      ),
      body: Padding(padding: EdgeInsets.all(12),
      child: Form(
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(label: Text('Name')),
                validator: (value){
                  if (value == null || value.trim().isEmpty || value.trim().length > 50) {
                    return 'Please enter a name up to 50 characters long.';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      label:Text("Quantity"),
                    ),
                    initialValue: '1',
                  ),
                ),
                const SizedBox(width:8),
                Expanded(
                  child: DropdownButtonFormField(items: [
                    for(final category in categories.entries)
                      DropdownMenuItem(
                        value:category.value,
                        child: Row(children: [
                        Container(
                          width:16, 
                          height:16,
                          color:category.value.color
                        ),
                        const SizedBox(width:6),
                        Text(category.value.name),
                      ],)
                      ,)
                  ], onChanged: (value){}),
                ),
              ],),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){}, child: Text("Reset"), ),
                  ElevatedButton(onPressed: (){}, child: Text("Add Item"), ),

              ],)
            ],
          ),
        ),
      ),

    );
  }
}
