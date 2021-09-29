library useful_utilities;

import 'package:flutter/material.dart';

/// [UsefulUtilities] is a class that contains useful utilities for the app.
class UsefulUtilities {}

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key? key,
    required this.itemBuilder,
    required this.snapshot,
  }) : super(key: key);

  final ItemWidgetBuilder itemBuilder;
  final AsyncSnapshot<List<T>> snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data ?? [];
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return _buildEmptyList();
      }
    } else if (snapshot.hasError) {
      return _buildError();
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }

  Widget _buildEmptyList() {
    return Container();
  }

  Widget _buildError() {
    return const Center(child: Text('Something went wrong.'));
  }
}
