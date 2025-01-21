import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';

import '../components/residential_card.dart';

class ResidentialBlock extends StatefulWidget {
  const ResidentialBlock({super.key});

  @override
  State<ResidentialBlock> createState() => _ResidentialBlockState();
}

class _ResidentialBlockState extends State<ResidentialBlock> {
  List<BuildHousingUnitCard>? residentialListSearch;
  List<BuildHousingUnitCard> residentialList = [];
  final _searchTextController = TextEditingController();
  bool _isSearching = false;
  Widget _buildSearchField() {
    return Expanded(
      child: Container(
        height: 40, // التحكم في ارتفاع الحاوية الكاملة
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 244, 246),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8.0), // تقليل الحشو حول الحقل
          child: TextField(
            textAlign: TextAlign.right,
            controller: _searchTextController,
            cursorColor: AppColor.primaryColor,
            decoration: const InputDecoration(
              hintText: 'بحث',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 133, 134, 137),
                fontSize: 18,
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 5.0), // التحكم في ارتفاع النص داخل الحقل
            ),
            style: const TextStyle(color: Colors.black, fontSize: 18),
            onChanged: (searcheResidental) {
              addSearchedForItemsToSearchedList(searcheResidental);
            },
          ),
        ),
      ),
    );
  }

  void addSearchedForItemsToSearchedList(String searcheResidental) {
    residentialListSearch = residentialList
        .where((residental) => residental.tital
            .toLowerCase()
            .contains(searcheResidental.toLowerCase()))
        .toList();
    setState(() {});
  }

  Widget _buildAppBarActions() {
    return IconButton(
      onPressed: _isSearching ? _stopSearching : _startSearch,
      icon: Icon(
        _isSearching ? Icons.clear : Icons.search,
        color: Colors.black,
        size: 28,
      ),
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    setState(() {
      _searchTextController.clear();
      _isSearching = false;
      residentialListSearch = null; // لإلغاء الفلترة وإظهار القائمة الكاملة
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                minimumSize: const Size(40, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "أضافة",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (_isSearching) _buildSearchField(),
            _buildAppBarActions(),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: residentialListSearch ?? residentialList,
            ),
          ),
        ),
      ],
    );
  }
}
