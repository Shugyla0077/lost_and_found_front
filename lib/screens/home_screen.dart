// home_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _didApplyInitialArgs = false;

  // Фильтры
  String? _selectedCategory;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didApplyInitialArgs) return;
    _didApplyInitialArgs = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['tab'] is int) {
      final tab = args['tab'] as int;
      if (tab >= 0 && tab <= 3 && (tab == 0 || _isAuthenticated)) {
        setState(() => _currentIndex = tab);
      }
    }
  }

  void _loadItems() {
    _itemsFuture = itemService.fetchItems(
      category: _selectedCategory,
      dateFrom: _dateFrom,
      dateTo: _dateTo,
    );
  }

  bool get _isAuthenticated => FirebaseAuth.instance.currentUser != null;

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

  String _titleForIndex(BuildContext context, int index) {
    switch (index) {
      case 1:
        return context.l10n.chats;
      case 2:
        return context.l10n.myItems;
      case 3:
        return context.l10n.profile;
      default:
        return context.l10n.appTitle;
    }
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
      ChatScreen(embedded: true, active: _currentIndex == 1),
      MyItemsScreen(embedded: true, active: _currentIndex == 2),
      ProfileScreen(embedded: true, active: _currentIndex == 3),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForIndex(context, _currentIndex)),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                if (!_isAuthenticated) {
                  final res = await Navigator.pushNamed(
                    context,
                    '/login',
                    arguments: {'popOnSuccess': true, 'next': '/addItem'},
                  );
                  if (!mounted) return;
                  if (res is Map && res['next'] == '/addItem') {
                    await Navigator.pushNamed(context, '/addItem');
                    if (!mounted) return;
                    await _refreshItems();
                  } else {
                    setState(() {});
                  }
                  return;
                }
                Navigator.pushNamed(context, '/addItem').then((_) => _refreshItems());
              },
            ),
          if (!_isAuthenticated)
            TextButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/login', arguments: {'popOnSuccess': true});
                if (!mounted) return;
                setState(() {});
              },
              child: Text(context.l10n.login),
            ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index != 0 && !_isAuthenticated) {
            Navigator.pushNamed(
              context,
              '/login',
              arguments: {'popOnSuccess': true, 'next': '/home', 'nextArgs': {'tab': index}},
            ).then((res) {
              if (!mounted) return;
              if (res is Map && res['next'] == '/home') {
                final nextArgs = res['nextArgs'];
                if (nextArgs is Map && nextArgs['tab'] is int) {
                  final tab = nextArgs['tab'] as int;
                  if (tab >= 0 && tab <= 3) {
                    setState(() => _currentIndex = tab);
                  }
                }
              }
              setState(() {});
            });
            return;
          }
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: context.l10n.chats,
          ),
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: context.l10n.myItems,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
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
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Кнопка фильтров
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                        foregroundColor: _hasActiveFilters ? scheme.primary : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (_hasActiveFilters) ...[
                    const SizedBox(width: 8),
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
          ),
        ),

        // Панель фильтров
        if (_showFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                // Категория
                DropdownButtonFormField<String>(
                  value: _tempCategory,
                  decoration: InputDecoration(
                    labelText: context.l10n.category,
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
                const SizedBox(height: 12),

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
                const SizedBox(height: 12),

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
                    const SizedBox(width: 8),
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
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(context.l10n.failedToLoadItems(details)),
                          ),
                        ),
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
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _hasActiveFilters
                                  ? context.l10n.noItemsMatchFilter
                                  : context.l10n.noItemsYet,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final statusBg = item.claimed ? scheme.tertiaryContainer : scheme.primaryContainer;
                    final statusFg = item.claimed ? scheme.onTertiaryContainer : scheme.onPrimaryContainer;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: statusBg,
                          foregroundColor: statusFg,
                          child: Icon(
                            item.claimed ? Icons.check : Icons.schedule,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: scheme.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.location,
                                    style: TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                // Категория
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: scheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.getCategoryName(locale),
                                    style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Статус
                                Icon(
                                  item.claimed ? Icons.verified : Icons.pending,
                                  size: 14,
                                  color: item.claimed ? scheme.tertiary : scheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.claimed ? context.l10n.claimed : context.l10n.available,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
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
