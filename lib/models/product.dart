class Product {
  final String productId;
  final String title;
  final String? description;
  final List<String> photos;
  final String? price;
  final String? originalPrice;
  final String? store;
  final String? productUrl;
  final double? rating;
  final int? reviewsCount;

  Product({
    required this.productId,
    required this.title,
    this.description,
    this.photos = const [],
    this.price,
    this.originalPrice,
    this.store,
    this.productUrl,
    this.rating,
    this.reviewsCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Extract photos
    List<String> photos = [];
    if (json['product_photos'] != null) {
      photos = List<String>.from(json['product_photos']);
    }

    // Extract offer data
    String? price;
    String? originalPrice;
    String? store;
    String? productUrl;

    if (json['offer'] != null) {
      final offer = json['offer'];
      price = offer['price']?.toString();
      originalPrice = offer['original_price']?.toString();
      store = offer['store_name']?.toString();
      productUrl = offer['product_url']?.toString() ??
                   offer['offer_page_url']?.toString();
    }

    // Fallback: try top_offers
    if (productUrl == null && json['top_offers'] != null) {
      final topOffers = json['top_offers'] as List<dynamic>?;
      if (topOffers != null && topOffers.isNotEmpty) {
        final firstOffer = topOffers.first;
        price ??= firstOffer['price']?.toString();
        store ??= firstOffer['store_name']?.toString();
        productUrl ??= firstOffer['product_url']?.toString() ??
                       firstOffer['offer_page_url']?.toString();
      }
    }

    return Product(
      productId: json['product_id']?.toString() ?? '',
      title: json['product_title']?.toString() ?? 'Unknown Product',
      description: json['product_description']?.toString(),
      photos: photos,
      price: price,
      originalPrice: originalPrice,
      store: store,
      productUrl: productUrl,
      rating: json['product_rating'] != null
          ? double.tryParse(json['product_rating'].toString())
          : null,
      reviewsCount: json['product_num_reviews'] != null
          ? int.tryParse(json['product_num_reviews'].toString())
          : null,
    );
  }
}
