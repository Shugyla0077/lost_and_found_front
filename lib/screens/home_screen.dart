// home_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import '../l10n/l10n.dart';
import 'chat_screen.dart';
import 'my_items_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ItemService itemService = GetIt.I<ItemService>();
  int _currentIndex = 0;
  late Future<List<Item>> _itemsFuture;

  // Фильтры
  String? _selectedCategory;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    _itemsFuture = itemService.fetchItems(
      category: _selectedCategory,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );
  }

  Future<void> _refreshItems() async {
    setState(() {
      _loadItems();
    });
    await _itemsFuture;
  }

  void _applyFilters({String? category, DateTime? dateFrom, DateTime? dateTo}) {
    setState(() {
      _selectedCategory = category;
      _dateFrom = dateFrom;
      _dateTo = dateTo;
      _loadItems();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = null;
      _dateFrom = null;
      _dateTo = null;
      _loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        itemsFuture: _itemsFuture,
        onRefresh: _refreshItems,
        selectedCategory: _selectedCategory,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        onApplyFilters: _applyFilters,
        onResetFilters: _resetFilters,
      ),
      ChatScreen(),
      MyItemsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addItem').then((_) => _refreshItems());
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFBDFF6C),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: context.l10n.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: context.l10n.chats,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: context.l10n.myItems,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: context.l10n.profile,
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    required this.itemsFuture,
    required this.onRefresh,
    required this.onApplyFilters,
    required this.onResetFilters,
    this.selectedCategory,
    this.dateFrom,
    this.dateTo,
  });

  final Future<List<Item>> itemsFuture;
  final Future<void> Function() onRefresh;
  final void Function({String? category, DateTime? dateFrom, DateTime? dateTo}) onApplyFilters;
  final void Function() onResetFilters;
  final String? selectedCategory;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showFilters = false;
  String? _tempCategory;
  DateTime? _tempDateFrom;
  DateTime? _tempDateTo;

  @override
  void initState() {
    super.initState();
    _tempCategory = widget.selectedCategory;
    _tempDateFrom = widget.dateFrom;
    _tempDateTo = widget.dateTo;
  }

  String _getLocale() {
    return Localizations.localeOf(context).languageCode;
  }

  bool get _hasActiveFilters =>
      widget.selectedCategory != null ||
      widget.dateFrom != null ||
      widget.dateTo != null;

  Future<void> _selectDateFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tempDateFrom ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tempDateFrom = picked;
      });
    }
  }

  Future<void> _selectDateTo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tempDateTo ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tempDateTo = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale();

    return Column(
      children: [
        // Кнопка фильтров
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                      if (_showFilters) {
                        _tempCategory = widget.selectedCategory;
                        _tempDateFrom = widget.dateFrom;
                        _tempDateTo = widget.dateTo;
                      }
                    });
                  },
                  icon: Icon(
                    _showFilters ? Icons.filter_list_off : Icons.filter_list,
                    size: 20,
                  ),
                  label: Text(context.l10n.filters),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _hasActiveFilters ? Colors.blue : Colors.grey[700],
                  ),
                ),
              ),
              if (_hasActiveFilters) ...[
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempCategory = null;
                      _tempDateFrom = null;
                      _tempDateTo = null;
                    });
                    widget.onResetFilters();
                  },
                  child: Text(context.l10n.resetFilters),
                ),
              ],
            ],
          ),
        ),

        // Панель фильтров
        if (_showFilters)
          Container(
            color: Colors.grey[100],
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Категория
                DropdownButtonFormField<String>(
                  value: _tempCategory,
                  decoration: InputDecoration(
                    labelText: context.l10n.category,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text(context.l10n.allCategories),
                    ),
                    ...itemCategories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.id,
                        child: Text(cat.getName(locale)),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _tempCategory = value;
                    });
                  },
                ),
                SizedBox(height: 12),

                // Даты
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _selectDateFrom,
                        child: Text(
                          '${context.l10n.dateFrom}: ${_formatDate(_tempDateFrom)}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _selectDateTo,
                        child: Text(
                          '${context.l10n.dateTo}: ${_formatDate(_tempDateTo)}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Кнопки применить/сбросить
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onApplyFilters(
                            category: _tempCategory,
                            dateFrom: _tempDateFrom,
                            dateTo: _tempDateTo,
                          );
                          setState(() {
                            _showFilters = false;
                          });
                        },
                        child: Text(context.l10n.applyFilters),
                      ),
                    ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _tempCategory = null;
                          _tempDateFrom = null;
                          _tempDateTo = null;
                        });
                      },
                      child: Text(context.l10n.clear),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // Список вещей
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: FutureBuilder<List<Item>>(
              future: widget.itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  final err = snapshot.error;
                  String details = err.toString();
                  if (err is DioException) {
                    final data = err.response?.data;
                    if (data is Map) {
                      final d = data.cast<String, dynamic>();
                      details = (d['detail'] ?? d['error'] ?? details).toString();
                    } else if (err.message != null && err.message!.isNotEmpty) {
                      details = err.message!;
                    }
                  }
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(context.l10n.failedToLoadItems(details)),
                      ),
                    ],
                  );
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _hasActiveFilters
                              ? context.l10n.noItemsMatchFilter
                              : context.l10n.noItemsYet,
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.claimed ? Colors.green : Colors.orange,
                          child: Icon(
                            item.claimed ? Icons.check : Icons.schedule,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: Colors.grey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.location,
                                    style: TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                // Категория
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.getCategoryName(locale),
                                    style: TextStyle(fontSize: 11, color: Colors.blue[700]),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Статус
                                Icon(
                                  item.claimed ? Icons.verified : Icons.pending,
                                  size: 14,
                                  color: item.claimed ? Colors.green : Colors.orange,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  item.claimed ? context.l10n.claimed : context.l10n.available,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: item.claimed ? Colors.green : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/itemDetail',
                            arguments: item,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
