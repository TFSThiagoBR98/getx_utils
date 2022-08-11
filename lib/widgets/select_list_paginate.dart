import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pagination/models/paginated_items_response.dart';
import '../pagination/sliver_paginated_builder.dart';

class SelectListPaginate<T> extends StatefulWidget {
  const SelectListPaginate(
      {Key? key,
      required this.onRefresh,
      required this.fetchPageData,
      required this.response,
      required this.itemBuilder,
      this.title,
      this.floatingActionButton,
      this.onItemTap})
      : super(key: key);

  final RefreshCallback onRefresh;
  final String? title;
  final Future<void> Function(bool reset) fetchPageData;
  final Rxn<PaginatedItemsResponse<T>> response;
  final Widget? floatingActionButton;
  final VoidCallback? onItemTap;
  final Widget Function(BuildContext, int, T) itemBuilder;

  @override
  State<SelectListPaginate<T>> createState() => _SelectListPaginateState<T>();
}

class _SelectListPaginateState<T> extends State<SelectListPaginate<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Selecione item para lista'),
        centerTitle: true,
      ),
      floatingActionButton: widget.floatingActionButton,
      body: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: Obx(() => CustomScrollView(slivers: [
              SliverPaginatedItemsBuilder<T>(
                fetchPageData: widget.fetchPageData,
                loaderItemsCount: 10,
                emptyText: 'Não há o que selecionar, cadastre novo item para continuar',
                response: widget.response.value,
                itemBuilder: (context, index, item) => GestureDetector(
                  onTap: widget.onItemTap ??
                      () {
                        Navigator.pop(context, item);
                      },
                  child: widget.itemBuilder(context, index, item),
                ),
              )
            ])),
      ),
    );
  }
}
