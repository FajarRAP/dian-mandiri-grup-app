import 'dart:async';

import 'package:flutter/material.dart';

class DropdownSearchModal extends StatefulWidget {
  const DropdownSearchModal({
    super.key,
    required this.search,
    required this.title,
    required this.child,
  });

  final void Function(String keyword) search;
  final String title;
  final Widget child;

  @override
  State<DropdownSearchModal> createState() => _DropdownSearchModalState();
}

class _DropdownSearchModalState extends State<DropdownSearchModal> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String search) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => widget.search(search),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: <Widget>[
        const SizedBox(height: 32),
        Text(
          'Pilih ${widget.title}',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Divider(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: _search,
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari ${widget.title}',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(height: 24),
        widget.child,
        const SizedBox(height: 24),
      ],
    );
  }
}
