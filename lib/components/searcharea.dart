import 'package:flutter/material.dart';
import '../components/constants/app_color.dart';

// ودجت البحث المخصصة
class SearchWidget<T> extends StatefulWidget {
  final List<T> originalList; // القائمة الأصلية
  final void Function(List<T>) onSearch; // دالة تُستدعى لتحديث القائمة المعروضة
  final String Function(T) searchCriteria; // دالة تحدد معيار البحث

  const SearchWidget({
    Key? key,
    required this.originalList,
    required this.onSearch,
    required this.searchCriteria,
  }) : super(key: key);

  @override
  _SearchWidgetState<T> createState() => _SearchWidgetState<T>();
}

class _SearchWidgetState<T> extends State<SearchWidget<T>> {
  final _searchTextController = TextEditingController();
  bool _isSearching = false;

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _searchTextController.clear();
      _isSearching = false;
      widget.onSearch(widget.originalList); // إرجاع القائمة الأصلية
    });
  }

  void _performSearch(String query) {
    final filteredList = widget.originalList
        .where((item) =>
            widget.searchCriteria(item).toLowerCase().contains(query.toLowerCase()))
        .toList();
    widget.onSearch(filteredList); // تحديث القائمة المعروضة
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isSearching)
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 244, 246),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _searchTextController,
                  textAlign: TextAlign.right,
                  cursorColor: AppColor.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'بحث',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 133, 134, 137),
                      fontSize: 18,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  onChanged: _performSearch,
                ),
              ),
            ),
          ),
        IconButton(
          onPressed: _isSearching ? _stopSearch : _startSearch,
          icon: Icon(
            _isSearching ? Icons.clear : Icons.search,
            color: Colors.black,
            size: 28,
          ),
        ),
      ],
    );
  }
}
