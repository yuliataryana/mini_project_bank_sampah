import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils.dart';
import '../../../viewmodel/main_viewmodel.dart';

class TabunganSampahScreen extends StatelessWidget {
  const TabunganSampahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor('#F0F6DC'),
      appBar: AppBar(
        title: const Text('Harga Sampah'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari jenis sampah',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              final items = context.watch<MainViewmodel>().itemsType;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () {
                          // navigate to /form-waste
                          Navigator.of(context).pushNamed('/form-waste');
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Center(
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () async {},
                      onLongPress: () {
                        showGeneralDialog<String>(
                          context: context,
                          pageBuilder: (_, anim, anim2) {
                            return ScaleTransition(
                              scale: anim,
                              child: AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                    Image.network(
                                      item.imageUrl,
                                      width: 250,
                                    ),
                                  ],
                                ),
                                actions: [
                                  // edit button
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).pushNamed(
                                        '/form-waste',
                                        arguments: item,
                                      );
                                    },
                                    child: const Text('Edit'),
                                  ),
                                  // delete button
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<MainViewmodel>()
                                          .deleteWasteItem(item.idWaste);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Image.network(item.imageUrl)),
                              Text(item.wasteName),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
