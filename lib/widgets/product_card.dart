import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isBestDeal;

  const ProductCard({
    super.key,
    required this.product,
    this.isBestDeal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isBestDeal
            ? Border.all(color: const Color(0xFF1A2B4A), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Best Deal Badge
          if (isBestDeal)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF1A2B4A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'BEST DEAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: product.photos.isNotEmpty
                      ? Image.network(
                          product.photos.first,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        )
                      : _placeholderImage(),
                ),
                const SizedBox(width: 12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Store name
                      if (product.store != null)
                        Row(
                          children: [
                            const Icon(Icons.store,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              product.store!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 6),

                      // Rating
                      if (product.rating != null)
                        Row(
                          children: [
                            ...List.generate(5, (i) {
                              return Icon(
                                i < product.rating!.floor()
                                    ? Icons.star
                                    : i < product.rating!
                                        ? Icons.star_half
                                        : Icons.star_border,
                                size: 14,
                                color: Colors.amber,
                              );
                            }),
                            const SizedBox(width: 4),
                            if (product.reviewsCount != null)
                              Text(
                                '(${product.reviewsCount})',
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
                              ),
                          ],
                        ),

                      const SizedBox(height: 8),

                      // Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.price != null)
                                Text(
                                  product.price!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A2B4A),
                                  ),
                                )
                              else
                                const Text(
                                  'Price unavailable',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              if (product.originalPrice != null &&
                                  product.originalPrice != product.price)
                                Text(
                                  product.originalPrice!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),

                          // View Deal Button
                          if (product.productUrl != null)
                            ElevatedButton(
                              onPressed: () =>
                                  _launchUrl(product.productUrl!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A2B4A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'View Deal',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey[100],
      child: const Icon(Icons.image_not_supported,
          color: Colors.grey, size: 30),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
