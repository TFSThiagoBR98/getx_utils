import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pagination/models/paginated_items_response.dart';
import '../utils/main_utils.dart';
import '../widgets/select_list_paginate.dart';
import 'getx_list_item.dart';

class GetXListMultiSelectController<T> {
  GetXListMultiSelectController(
      {this.checkIcon = const Icon(Icons.check_box),
      this.uncheckIcon = const Icon(Icons.check_box_outline_blank),
      this.titleTextStyle = const TextStyle(
        fontSize: 18,
      ),
      required this.fetchPageData,
      required this.response,
      Map<String, GetXListItem<T>>? value}) {
    selectEntries.addAll(value ?? {});
  }

  final Future<void> Function({bool reset, bool showLoaderOnReset}) fetchPageData;

  final Rx<TextEditingController> _itemController = TextEditingController().obs;
  TextEditingController get itemController => _itemController.value;
  set itemController(TextEditingController value) => _itemController.value = value;

  final RxMap<String, GetXListItem<T>> _initialMap = <String, GetXListItem<T>>{}.obs;
  Map<String, GetXListItem<T>> get initialMap => _initialMap;
  set initialMap(Map<String, GetXListItem<T>> value) => _initialMap.assignAll(value);

  final RxMap<String, GetXListItem<T>> _selectEntries = <String, GetXListItem<T>>{}.obs;
  Map<String, GetXListItem<T>> get selectEntries => _selectEntries;
  set selectEntries(Map<String, GetXListItem<T>> value) => _selectEntries.assignAll(value);

  final Rxn<PaginatedItemsResponse<MapEntry<String, GetXListItem<T>>>> response;

  final TextStyle? titleTextStyle;

  final Widget? checkIcon;
  final Widget? uncheckIcon;

  void resetFields() {
    selectEntries.clear();
    itemController.text = '';
  }

  bool isSelected(MapEntry<String, GetXListItem<T>> item) {
    return selectEntries.containsKey(item.key);
  }

  String mountSelectList() {
    return selectEntries.values.map((e) => e).join(', ');
  }

  void selectItem(MapEntry<String, GetXListItem<T>> item) {
    selectEntries.addEntries([item]);
    itemController.text = mountSelectList();
  }

  void deselectItem(MapEntry<String, GetXListItem<T>> item) {
    selectEntries.remove(item.key);
    itemController.text = mountSelectList();
  }

  Map<String, GetXListItem<T>> getMapAdded() {
    Map<String, GetXListItem<T>> diff = {};
    for (final item in selectEntries.keys) {
      if (!initialMap.containsKey(item)) {
        diff[item] = selectEntries[item]!;
      }
    }
    return diff;
  }

  Map<String, GetXListItem<T>> getMapRemoved() {
    Map<String, GetXListItem<T>> diff = {};
    for (final item in initialMap.keys) {
      if (!selectEntries.containsKey(item)) {
        diff[item] = initialMap[item]!;
      }
    }
    return diff;
  }

  void showList() {
    Navigator.push<dynamic>(
        appContext!,
        MaterialPageRoute<dynamic>(
            builder: (context) => SelectListPaginate<MapEntry<String, GetXListItem<T>>>(
                onRefresh: () async => fetchPageData(reset: true, showLoaderOnReset: true),
                fetchPageData: (reset) => fetchPageData(reset: reset, showLoaderOnReset: reset),
                response: response,
                onItemTap: () {},
                title: 'Selecione um ou mais itens',
                floatingActionButton: FloatingActionButton.extended(
                  label: const Text('Salvar'),
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    Navigator.of(context).pop(selectEntries);
                  },
                ),
                itemBuilder: (context, index, item) {
                  return Obx(
                    () => ListTile(
                      leading: isSelected(item) ? checkIcon : uncheckIcon,
                      title: Text(
                        item.value.label,
                        style: titleTextStyle,
                      ),
                      onTap: () {
                        if (isSelected(item)) {
                          deselectItem(item);
                        } else {
                          selectItem(item);
                        }
                      },
                    ),
                  );
                })));
  }
}
