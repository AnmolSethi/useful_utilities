library useful_utilities;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

part 'extensions/context_extension.dart';
part 'api/api.service.dart';

/// [UsefulUtilities] is a class that contains useful utilities for the app.
class UsefulUtilities {
  /// Extracts the url from the data.
  String extractUrl(String data) {
    return data.substring(data.indexOf('https'), data.indexOf('.com') + 4);
  }
}

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key? key,
    required this.itemBuilder,
    required this.snapshot,
    this.emptyWidget = const Center(child: Text('No items')),
    this.errorWidget = const Center(child: Text('Something went wrong.')),
  }) : super(key: key);

  final ItemWidgetBuilder itemBuilder;
  final AsyncSnapshot<List<T>> snapshot;
  final Widget emptyWidget;
  final Widget errorWidget;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data ?? [];
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return emptyWidget;
      }
    } else if (snapshot.hasError) {
      return errorWidget;
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}
