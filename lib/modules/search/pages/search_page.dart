import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_template_1/components/molecules/app_bar/custom_appbar.dart';
import 'package:flutter_base_template_1/components/molecules/search_input_box/custom_search_input_box.dart';
import 'package:flutter_base_template_1/generated/l10n.dart';
import 'package:flutter_base_template_1/modules/search/bloc/search_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchFocus = FocusNode();
  Timer? _timer;
  final _searchBloc = Modular.get<SearchBloc>();

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: CustomSearchInputBox(
          hintText: S.current.searchEvents,
          onChanged: _onQueryChanged,
          focusNode: _searchFocus,
        ),
      ),
    );
  }

  void _onQueryChanged(String query) {
    _debounce(const Duration(milliseconds: 500), () {
      _searchBloc.fetchEvents(query);
    });
  }

  void _debounce(Duration duration, void Function() callback) {
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(duration, callback);
  }
}
