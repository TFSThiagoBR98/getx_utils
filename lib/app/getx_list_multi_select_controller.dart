import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'getx_list_item.dart';
import '../pagination/models/paginated_items_response.dart';
import '../widgets/select_list_paginate.dart';

class GetXListMultiSelectController {
  GetXListMultiSelectController(
      {this.checkIcon = const Icon(Icons.check_box),
      this.uncheckIcon = const Icon(Icons.check_box_outline_blank),
      this.titleTextStyle = const TextStyle(
        fontSize: 18,
      ),
      required this.fetchPageData,
      required this.response,
      Map<String, GetXListItem>? value}) {
    selectEntries.addAll(value ?? {});
  }

  final Future<void> Function({bool reset, bool showLoaderOnReset}) fetchPageData;

  final Rx<TextEditingController> _itemController = TextEditingController().obs;
  TextEditingController get itemController => _itemController.value;
  set itemController(TextEditingController value) => _itemController.value = value;

  final RxMap<String, GetXListItem> _initialMap = <String, GetXListItem>{}.obs;
  Map<String, GetXListItem> get initialMap => _initialMap;
  set initialMap(Map<String, GetXListItem> value) => _initialMap.assignAll(value);

  final RxMap<String, GetXListItem> _selectEntries = <String, GetXListItem>{}.obs;
  Map<String, GetXListItem> get selectEntries => _selectEntries;
  set selectEntries(Map<String, GetXListItem> value) => _selectEntries.assignAll(value);

  final Rxn<PaginatedItemsResponse<MapEntry<String, GetXListItem>>> response;

  final TextStyle? titleTextStyle;

  final Widget? checkIcon;
  final Widget? uncheckIcon;

  void resetFields() {
    selectEntries.clear();
    itemController.text = "";
  }

  bool isSelected(MapEntry<String, GetXListItem> item) {
    return selectEntries.containsKey(item.key);
  }

  String mountSelectList() {
    return selectEntries.values.map((e) => e).join(', ');
  }

  void selectItem(MapEntry<String, GetXListItem> item) {
    selectEntries.addEntries([item]);
    itemController.text = mountSelectList();
  }

  void deselectItem(MapEntry<String, GetXListItem> item) {
    selectEntries.remove(item.key);
    itemController.text = mountSelectList();
  }

  Map<String, GetXListItem> getMapAdded() {
    Map<String, GetXListItem> diff = {};
    for (var item in selectEntries.keys) {
      if (!initialMap.containsKey(item)) {
        diff[item] = selectEntries[item]!;
      }
    }
    return diff;
  }

  Map<String, GetXListItem> getMapRemoved() {
    Map<String, GetXListItem> diff = {};
    for (var item in initialMap.keys) {
      if (!selectEntries.containsKey(item)) {
        diff[item] = initialMap[item]!;
      }
    }
    return diff;
  }

  void showList() {
    Navigator.push(
        Get.context!,
        MaterialPageRoute(
            builder: (context) => SelectListPaginate<MapEntry<String, GetXListItem>>(
                onRefresh: () async => fetchPageData(reset: true, showLoaderOnReset: true),
                fetchPageData: (reset) => fetchPageData(reset: reset, showLoaderOnReset: reset),
                response: response,
                onItemTap: () {},
                title: "Selecione um ou mais itens",
                floatingActionButton: FloatingActionButton.extended(
                  label: const Text("Salvar"),
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
