// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart_scanner/pages/item/provider/widget_card_provider/widget_card_items_provider.dart';

class CustomTextFormSearchItems extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const CustomTextFormSearchItems({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomTextFormSearchItemsState();
}

class _CustomTextFormSearchItemsState
    extends ConsumerState<CustomTextFormSearchItems> {
  @override
  Widget build(BuildContext context) {
    final cardWidetsRef = ref.watch(widgetCardItemsProvider);
    bool isGrid = cardWidetsRef.isGrid;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(18.0),
        ),
        border: Border.all(
          width: 0.8,
          color: Colors.grey[400]!,
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextFormField(
              initialValue: null,
              controller: widget.controller,
              decoration: const InputDecoration.collapsed(
                filled: true,
                fillColor: Colors.transparent,
                hintText: "Search",
                hoverColor: Colors.transparent,
              ),
              onChanged: widget.onChanged,
              onFieldSubmitted: (value) {},
            ),
          ),
          InkWell(
            onTap: () {
              cardWidetsRef.changeIsGrid();
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isGrid
                    ? const Icon(
                        Icons.list_rounded,
                        size: 20.0,
                      )
                    : const Icon(
                        Icons.grid_on_rounded,
                        size: 20.0,
                      )),
          ),
        ],
      ),
    );
  }
}
