import 'package:flutter/material.dart';

import '../../common/utils.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({
    super.key,
    this.child,
    this.initialValue = 1,
    this.submitLabel,
  });
  final Widget? child;
  final double? initialValue;
  final String? submitLabel;

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue.toString());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: const Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.child ?? const SizedBox(),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Jumlah Sampah (Kg)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // backgroundColor: hexToColor("#7A9D30"),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Batal'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(8),
            foregroundColor: Color(0xFFFFFFFF),
            backgroundColor: hexToColor("#7A9D30"),
          ),
          onPressed: () {
            Navigator.pop(context, _controller.text);
          },
          child: Text(widget.submitLabel ?? 'Tambah'),
        ),
      ],
    );
  }
}
