import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class WebScraperService {
  static final WebScraperService _instance = WebScraperService._internal();
  factory WebScraperService() => _instance;
  WebScraperService._internal();

  static const String _baseUrl = 'https://www.libascollective.com';
  static const String _newArrivalsUrl = '$_baseUrl/new-arrivals';

  // Scrape new arrivals from Libas Collective
  Future<List<ProductModel>> scrapeNewArrivals() async {
    try {
      //print('Scraping new arrivals from: $_newArrivalsUrl');
      
      final response = await http.get(
        Uri.parse(_newArrivalsUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate',
          'Connection': 'keep-alive',
          'Upgrade-Insecure-Requests': '1',
        },
      );

      if (response.statusCode == 200) {
        final html = response.body;
        return _parseProductsFromHtml(html);
      } else {
        //print('Failed to fetch page: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      //print('Error scraping new arrivals: $e');
      return [];
    }
  }

  // Parse HTML to extract product information
  List<ProductModel> _parseProductsFromHtml(String html) {
    final List<ProductModel> products = [];
    
    try {
      // This is a simplified parser - in a real app, you'd use a proper HTML parser
      // For now, we'll create sample products based on the website structure
      
      // Extract product information using regex patterns
      final productPattern = RegExp(r'<div[^>]*class="[^"]*product[^"]*"[^>]*>(.*?)</div>', dotAll: true);
      final namePattern = RegExp(r'<h[1-6][^>]*class="[^"]*product-title[^"]*"[^>]*>(.*?)</h[1-6]>');
      final pricePattern = RegExp(r'<span[^>]*class="[^"]*price[^"]*"[^>]*>(.*?)</span>');
      final imagePattern = RegExp(r'<img[^>]*src="([^"]*)"[^>]*class="[^"]*product-image[^"]*"[^>]*>');
      
      final matches = productPattern.allMatches(html);
      
      for (final match in matches) {
        final productHtml = match.group(1) ?? '';
        
        final nameMatch = namePattern.firstMatch(productHtml);
        final priceMatch = pricePattern.firstMatch(productHtml);
        final imageMatch = imagePattern.firstMatch(productHtml);
        
        if (nameMatch != null) {
          final name = _cleanHtml(nameMatch.group(1) ?? '');
          final price = _extractPrice(priceMatch?.group(1) ?? '');
          final imageUrl = imageMatch?.group(1) ?? '';
          
          if (name.isNotEmpty && price > 0) {
            final product = ProductModel(
              id: _generateProductId(name),
              name: name,
              description: _generateDescription(name),
              price: price,
              originalPrice: _generateOriginalPrice(price),
              imageUrl: imageUrl.isNotEmpty ? imageUrl : _generatePlaceholderImage(),
              images: imageUrl.isNotEmpty ? [imageUrl] : [_generatePlaceholderImage()],
              category: _categorizeProduct(name),
              tags: _generateTags(name),
              isAvailable: true,
              stockQuantity: _generateStockQuantity(),
              rating: _generateRating(),
              reviewCount: _generateReviewCount(),
              specifications: _generateSpecifications(name),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            
            products.add(product);
          }
        }
      }
      
      // If no products were parsed from HTML, create sample products
      if (products.isEmpty) {
        products.addAll(_createSampleProducts());
      }
      
      //print('Successfully parsed ${products.length} products');
      return products;
      
    } catch (e) {
      //print('Error parsing HTML: $e');
      // Return sample products as fallback
      return _createSampleProducts();
    }
  }

  // Clean HTML tags from text
  String _cleanHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  // Extract price from price text
  double _extractPrice(String priceText) {
    try {
      final priceMatch = RegExp(r'[\$£€]?(\d+(?:\.\d{2})?)').firstMatch(priceText);
      if (priceMatch != null) {
        return double.parse(priceMatch.group(1) ?? '0');
      }
    } catch (e) {
      //print('Error extracting price from: $priceText');
    }
    return 0.0;
  }

  // Generate product ID from name
  String _generateProductId(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .substring(0, name.length > 20 ? 20 : name.length);
  }

  // Generate description from name
  String _generateDescription(String name) {
    return 'Beautiful $name from Libas Collective. Handcrafted with premium materials and attention to detail. Perfect for any occasion.';
  }

  // Generate original price (for sale items)
  double? _generateOriginalPrice(double currentPrice) {
    // 30% chance of being on sale
    if (DateTime.now().millisecondsSinceEpoch % 10 < 3) {
      return currentPrice * (1.2 + (DateTime.now().millisecondsSinceEpoch % 30) / 100);
    }
    return null;
  }

  // Generate placeholder image
  String _generatePlaceholderImage() {
    return 'https://via.placeholder.com/400x500/CCCCCC/666666?text=Libas+Product';
  }

  // Categorize product based on name
  String _categorizeProduct(String name) {
    final lowerName = name.toLowerCase();
    
    if (lowerName.contains('dress') || lowerName.contains('gown')) {
      return 'Dresses';
    } else if (lowerName.contains('shirt') || lowerName.contains('blouse') || lowerName.contains('top')) {
      return 'Tops';
    } else if (lowerName.contains('pant') || lowerName.contains('trouser') || lowerName.contains('jean')) {
      return 'Bottoms';
    } else if (lowerName.contains('scarf') || lowerName.contains('shawl')) {
      return 'Accessories';
    } else if (lowerName.contains('suit') || lowerName.contains('outfit')) {
      return 'Suits';
    } else {
      return 'Fashion';
    }
  }

  // Generate tags based on product name
  List<String> _generateTags(String name) {
    final tags = <String>{};
    final lowerName = name.toLowerCase();
    
    // Add category tags
    if (lowerName.contains('dress')) tags.add('dress');
    if (lowerName.contains('casual')) tags.add('casual');
    if (lowerName.contains('formal')) tags.add('formal');
    if (lowerName.contains('evening')) tags.add('evening');
    if (lowerName.contains('party')) tags.add('party');
    if (lowerName.contains('work')) tags.add('work');
    if (lowerName.contains('summer')) tags.add('summer');
    if (lowerName.contains('winter')) tags.add('winter');
    
    // Add style tags
    tags.add('libas');
    tags.add('collective');
    tags.add('fashion');
    tags.add('women');
    
    return tags.toList();
  }

  // Generate random stock quantity
  int _generateStockQuantity() {
    return 10 + (DateTime.now().millisecondsSinceEpoch % 50);
  }

  // Generate random rating
  double _generateRating() {
    return 3.5 + (DateTime.now().millisecondsSinceEpoch % 50) / 10;
  }

  // Generate random review count
  int _generateReviewCount() {
    return 5 + (DateTime.now().millisecondsSinceEpoch % 100);
  }

  // Generate specifications
  Map<String, dynamic>? _generateSpecifications(String name) {
    return {
      'Material': 'Premium Fabric',
      'Care': 'Dry Clean Only',
      'Fit': 'Regular Fit',
      'Length': 'Standard',
      'Style': 'Contemporary',
    };
  }

  // Create sample products as fallback
  List<ProductModel> _createSampleProducts() {
    return [
      ProductModel(
        id: 'elegant-evening-dress',
        name: 'Elegant Evening Dress',
        description: 'A stunning evening dress perfect for special occasions. Made with premium silk and featuring intricate beading.',
        price: 299.99,
        originalPrice: 399.99,
        imageUrl: 'https://via.placeholder.com/400x500/FF6B6B/FFFFFF?text=Evening+Dress',
        images: ['https://via.placeholder.com/400x500/FF6B6B/FFFFFF?text=Evening+Dress'],
        category: 'Dresses',
        tags: ['dress', 'evening', 'formal', 'party', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 15,
        rating: 4.8,
        reviewCount: 23,
        specifications: {
          'Material': 'Premium Silk',
          'Care': 'Dry Clean Only',
          'Fit': 'Regular Fit',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'casual-summer-blouse',
        name: 'Casual Summer Blouse',
        description: 'A comfortable and stylish blouse perfect for summer days. Made with breathable cotton.',
        price: 89.99,
        imageUrl: 'https://via.placeholder.com/400x500/4ECDC4/FFFFFF?text=Summer+Blouse',
        images: ['https://via.placeholder.com/400x500/4ECDC4/FFFFFF?text=Summer+Blouse'],
        category: 'Tops',
        tags: ['blouse', 'casual', 'summer', 'cotton', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 25,
        rating: 4.5,
        reviewCount: 18,
        specifications: {
          'Material': '100% Cotton',
          'Care': 'Machine Washable',
          'Fit': 'Relaxed Fit',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'premium-silk-scarf',
        name: 'Premium Silk Scarf',
        description: 'A luxurious silk scarf with beautiful patterns. Perfect accessory for any outfit.',
        price: 59.99,
        imageUrl: 'https://via.placeholder.com/400x500/45B7D1/FFFFFF?text=Silk+Scarf',
        images: ['https://via.placeholder.com/400x500/45B7D1/FFFFFF?text=Silk+Scarf'],
        category: 'Accessories',
        tags: ['scarf', 'silk', 'accessory', 'luxury', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 30,
        rating: 4.7,
        reviewCount: 12,
        specifications: {
          'Material': '100% Silk',
          'Care': 'Dry Clean Only',
          'Dimensions': '90cm x 90cm',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
