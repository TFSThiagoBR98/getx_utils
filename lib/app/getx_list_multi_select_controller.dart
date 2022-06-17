import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pagination/models/paginated_items_response.dart';
import '../widgets/select_list_paginate.dart';

class GetXListMultiSelectController {
  final Future<void> Function({bool reset, bool showLoaderOnReset}) fetchPageData;

  final Rx<TextEditingController> _itemController = TextEditingController().obs;
  TextEditingController get itemController => _itemController.value;
  set itemController(TextEditingController value) => _itemController.value = value;

  final RxMap<String, String> _initialMap = <String, String>{}.obs;
  Map<String, String> get initialMap => _initialMap;
  set initialMap(Map<String, String> value) => _initialMap.assignAll(value);

  final RxMap<String, String> _selectEntries = <String, String>{}.obs;
  Map<String, String> get selectEntries => _selectEntries;
  set selectEntries(Map<String, String> value) => _selectEntries.assignAll(value);

  final Rxn<PaginatedItemsResponse<MapEntry<String, String>>> response;

  void resetFields() {
    selectEntries.clear();
    itemController.text = "";
  }

  bool isSelected(MapEntry<String, String> item) {
    return selectEntries.containsKey(item.key);
  }

  String mountSelectList() {
    return selectEntries.values.map((e) => e).join(', ');
  }

  void selectItem(MapEntry<String, String> item) {
    selectEntries.addEntries([item]);
    itemController.text = mountSelectList();
  }

  void deselectItem(MapEntry<String, String> item) {
    selectEntries.remove(item.key);
    itemController.text = mountSelectList();
  }

  Map<String, String> getMapAdded() {
    Map<String, String> diff = {};
    for (var item in selectEntries.keys) {
      if (!initialMap.containsKey(item)) {
        diff[item] = selectEntries[item]!;
      }
    }
    return diff;
  }

  Map<String, String> getMapRemoved() {
    Map<String, String> diff = {};
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
            builder: (context) => SelectListPaginate<MapEntry<String, String>>(
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
                      leading:
                          isSelected(item) ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                      title: Text(item.value),
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

  GetXListMultiSelectController({required this.fetchPageData, required this.response, Map<String, String>? value}) {
    selectEntries.addAll(value ?? {});
  }
}
