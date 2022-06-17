import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pagination/models/paginated_items_response.dart';
import '../widgets/select_list_paginate.dart';

class GetXListSelectController {
  final Future<void> Function({bool reset, bool showLoaderOnReset}) fetchPageData;

  final Rx<TextEditingController> _itemController = TextEditingController().obs;
  TextEditingController get itemController => _itemController.value;
  set itemController(TextEditingController value) => _itemController.value = value;

  final Rxn<MapEntry<String, String>> _selectEntry = Rxn<MapEntry<String, String>>();
  MapEntry<String, String>? get selectEntry => _selectEntry.value;
  set selectEntry(MapEntry<String, String>? value) => _selectEntry.value = value;

  final Rxn<PaginatedItemsResponse<MapEntry<String, String>>> response;

  void resetFields() {
    selectEntry = null;
    itemController.text = "";
  }

  void selectItem(MapEntry<String, String> item) {
    selectEntry = item;
    itemController.text = item.value;
  }

  void showList() {
    Navigator.push(
        Get.context!,
        MaterialPageRoute(
            builder: (context) => SelectListPaginate<MapEntry<String, String>>(
                onRefresh: () async => fetchPageData(reset: true, showLoaderOnReset: true),
                fetchPageData: (reset) => fetchPageData(reset: reset, showLoaderOnReset: reset),
                response: response,
                itemBuilder: (context, index, item) {
                  return ListTile(
                    leading: const Icon(Icons.list),
                    title: Text(item.value),
                    onTap: () {
                      selectItem(item);
                      Navigator.of(context).pop(item);
                    },
                  );
                })));
  }

  GetXListSelectController({required this.fetchPageData, required this.response, MapEntry<String, String>? value}) {
    selectEntry = value;
  }
}
