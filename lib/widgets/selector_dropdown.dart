import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../app/getx_list_item.dart';

class SelectorDropdownFormfield<T> extends StatelessWidget {
  final ValueChanged<GetXListItem<T>?>? onChanged;
  final String? labelText;
  final bool visible;
  final bool isDense;
  final bool filled;
  final Color? fillColor;
  final List<GetXListItem<T>> items;
  final TextStyle? hintStyle;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final EdgeInsetsGeometry? contentPadding;
  final GestureTapCallback? onTap;
  final FormFieldValidator<GetXListItem<T>?>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final InputBorder? border;
  final EdgeInsetsGeometry externalPadding;
  final TextStyle? style;
  final GetXListItem<T>? selectedItem;
  final String? helperText;
  final String? hintText;

  const SelectorDropdownFormfield(
      {super.key,
      this.onChanged,
      this.labelText,
      this.visible = true,
      this.prefixIcon,
      this.suffixIcon,
      this.externalPadding = const EdgeInsets.all(8.0),
      this.style,
      this.border = const OutlineInputBorder(),
      this.validator,
      this.focusNode,
      this.isDense = false,
      this.filled = true,
      this.fillColor,
      this.hintStyle,
      this.enabledBorder,
      this.focusedBorder,
      this.contentPadding,
      this.helperText,
      this.hintText,
      this.onTap,
      required this.items,
      this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: externalPadding,
        child: DropdownSearch<GetXListItem<T>>(
          popupProps: const PopupProps.menu(
            showSelectedItems: true,
          ),
          items: items,
          dropdownBuilder: ((context, selectedItem) {
            return Text(selectedItem?.label ?? '',
                style: Theme.of(context).textTheme.titleMedium);
          }),
          itemAsString: (item) => item.label,
          compareFn: (item1, item2) => item1.id == item2.id,
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: style,
            dropdownSearchDecoration: InputDecoration(
                suffixIcon: suffixIcon,
                border: border,
                isDense: isDense,
                filled: filled,
                fillColor: fillColor,
                hintText: hintText,
                hintStyle: hintStyle,
                enabledBorder: enabledBorder,
                focusedBorder: focusedBorder,
                contentPadding: contentPadding,
                prefixIcon: prefixIcon,
                helperText: helperText,
                labelText: labelText),
          ),
          validator: validator,
          onChanged: onChanged,
          selectedItem: selectedItem,
        ),
      ),
    );
  }
}
