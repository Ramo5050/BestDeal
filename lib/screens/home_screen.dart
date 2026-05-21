import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _availableStores = [];
  String _selectedStore = 'All Stores';
  bool _isLoading = false;
  String? _error;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _hasSearched = true;
      _selectedStore = 'All Stores';
    });

    try {
      final products = await ApiService.searchProducts(query);

      // Sort by price
      products.sort((a, b) {
        final priceA = _parsePrice(a.price);
        final priceB = _parsePrice(b.price);
        if (priceA == null && priceB == null) return 0;
        if (priceA == null) return 1;
        if (priceB == null) return -1;
        return priceA.compareTo(priceB);
      });

      // Extract unique store names
      final stores = products
          .where((p) => p.store != null && p.store!.isNotEmpty)
          .map((p) => p.store!)
          .toSet()
          .toList();
      stores.sort();

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _availableStores = ['All Stores', ...stores];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong. Please check your API key and try again.';
        _isLoading = false;
      });
    }
  }

  void _filterByStore(String? store) {
    if (store == null) return;
    setState(() {
      _selectedStore = store;
      if (store == 'All Stores') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts =
            _allProducts.where((p) => p.store == store).toList();
      }
    });
  }

  double? _parsePrice(String? price) {
    if (price == null) return null;
    final cleaned = price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2B4A),
        elevation: 0,
        title: const Text(
          'BestDeal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            color: const Color(0xFF1A2B4A),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'Search for a product...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFF1A2B4A)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _search,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1A2B4A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Search BestDeal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Store Filter Dropdown
          if (_hasSearched && !_isLoading && _availableStores.length > 1)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  const Text(
                    'Filter by store:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1A2B4A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF1A2B4A).withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStore,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Color(0xFF1A2B4A)),
                          style: const TextStyle(
                            color: Color(0xFF1A2B4A),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: _filterByStore,
                          items: _availableStores.map((store) {
                            return DropdownMenuItem<String>(
                              value: store,
                              child: Row(
                                children: [
                                  Icon(
                                    store == 'All Stores'
                                        ? Icons.store
                                        : Icons.shopping_bag_outlined,
                                    size: 16,
                                    color: const Color(0xFF1A2B4A),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(store),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Results Section
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1A2B4A)),
            SizedBox(height: 16),
            Text(
              'Finding best deals...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Search for any product\nto find the best deal!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_mall_directory_outlined,
                size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              _selectedStore == 'All Stores'
                  ? 'No products found.\nTry a different search term.'
                  : 'No products found from $_selectedStore.\nTry selecting a different store.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Text(
                '${_filteredProducts.length} results',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2B4A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _selectedStore == 'All Stores'
                      ? 'Sorted by best price'
                      : _selectedStore,
                  style: const TextStyle(
                    color: Color(0xFF1A2B4A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: _filteredProducts[index],
                isBestDeal: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
