import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead_example/product.dart';

class CheckoutDialog extends StatelessWidget {
  const CheckoutDialog({
    super.key,
    required this.products,
  });

  final ProductController products;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Would you like to check out for \$${products.total}?'),
          Text(
            'This will clear your shopping cart.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            products.value = {};
          },
          child: const Text('CONFIRM'),
        ),
      ],
    );
  }
}

class CupertinoCheckoutDialog extends StatelessWidget {
  const CupertinoCheckoutDialog({
    super.key,
    required this.products,
  });

  final ProductController products;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Are you sure?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Would you like to check out for \$${products.total}?'),
          Text(
            'This will clear your shopping cart.',
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 14,
                ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
            products.value = {};
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
