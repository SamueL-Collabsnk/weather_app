import 'package:flutter/material.dart';

class SearchCityWidget extends StatefulWidget {
  final Function(String) onSearch;
  final bool isDarkMode;

  const SearchCityWidget({
    required this.onSearch,
    required this.isDarkMode,
    super.key,
  });

  @override
  State<SearchCityWidget> createState() => _SearchCityWidgetState();
}

class _SearchCityWidgetState extends State<SearchCityWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  widget.onSearch(value);
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                }
              },
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle: TextStyle(
                  color: widget.isDarkMode
                      ? Colors.grey[500]
                      : Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: widget.isDarkMode
                      ? Colors.grey[500]
                      : Colors.grey[600],
                ),
                filled: true,
                fillColor: widget.isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.cyan[300]!],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onSearch(_controller.text);
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                }
              },
              icon: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
