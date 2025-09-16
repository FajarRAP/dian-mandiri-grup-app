import 'package:flutter/material.dart';

import '../helpers/debouncer.dart';

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
  late final Debouncer _debouncer;
  late final FocusNode _focusNode;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _focusNode = FocusScope.of(context, createDependency: false);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
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
            onChanged: (value) => _debouncer.run(() => widget.search(value)),
            onTapOutside: (event) => _focusNode.unfocus(),
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari ${widget.title}',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(height: 12),
        widget.child,
        const SizedBox(height: 12),
      ],
    );
  }
}
