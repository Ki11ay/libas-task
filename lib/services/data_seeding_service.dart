import '../models/product_model.dart';
import '../services/web_scraper_service.dart';
import '../services/product_service.dart';

class DataSeedingService {
  static final DataSeedingService _instance = DataSeedingService._internal();
  factory DataSeedingService() => _instance;
  DataSeedingService._internal();

  final WebScraperService _webScraperService = WebScraperService();
  final ProductService _productService = ProductService();

  // Seed products from web scraping
  Future<void> seedProductsFromWeb() async {
    try {
      print('Starting product seeding from web...');
      
      // Scrape products from Libas Collective website
      final List<ProductModel> scrapedProducts = await _webScraperService.scrapeNewArrivals();
      
      if (scrapedProducts.isEmpty) {
        print('No products were scraped, using sample products instead');
        return;
      }

      print('Scraped ${scrapedProducts.length} products from website');
      
      // Add each product to Firestore
      int successCount = 0;
      int errorCount = 0;
      
      for (final product in scrapedProducts) {
        try {
          await _productService.addProduct(product);
          successCount++;
          print('Added product: ${product.name}');
        } catch (e) {
          errorCount++;
          print('Error adding product ${product.name}: $e');
        }
        
        // Add a small delay to avoid overwhelming Firestore
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      print('Product seeding completed!');
      print('Successfully added: $successCount products');
      if (errorCount > 0) {
        print('Failed to add: $errorCount products');
      }
      
    } catch (e) {
      print('Error during product seeding: $e');
    }
  }

  // Seed sample products (fallback)
  Future<void> seedSampleProducts() async {
    try {
      print('Starting sample product seeding...');
      
      final List<ProductModel> sampleProducts = _createSampleProducts();
      
      int successCount = 0;
      int errorCount = 0;
      
      for (final product in sampleProducts) {
        try {
          await _productService.addProduct(product);
          successCount++;
          print('Added sample product: ${product.name}');
        } catch (e) {
          errorCount++;
          print('Error adding sample product ${product.name}: $e');
        }
        
        // Add a small delay to avoid overwhelming Firestore
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      print('Sample product seeding completed!');
      print('Successfully added: $successCount products');
      if (errorCount > 0) {
        print('Failed to add: $errorCount products');
      }
      
    } catch (e) {
      print('Error during sample product seeding: $e');
    }
  }

  // Create comprehensive sample products
  List<ProductModel> _createSampleProducts() {
    return [
      // Dresses
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
        id: 'casual-summer-dress',
        name: 'Casual Summer Dress',
        description: 'A comfortable and stylish summer dress perfect for warm days. Made with breathable cotton.',
        price: 89.99,
        imageUrl: 'https://via.placeholder.com/400x500/4ECDC4/FFFFFF?text=Summer+Dress',
        images: ['https://via.placeholder.com/400x500/4ECDC4/FFFFFF?text=Summer+Dress'],
        category: 'Dresses',
        tags: ['dress', 'casual', 'summer', 'cotton', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 20,
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
      
      // Tops
      ProductModel(
        id: 'casual-summer-blouse',
        name: 'Casual Summer Blouse',
        description: 'A comfortable and stylish blouse perfect for summer days. Made with breathable cotton.',
        price: 89.99,
        imageUrl: 'https://via.placeholder.com/400x500/45B7D1/FFFFFF?text=Summer+Blouse',
        images: ['https://via.placeholder.com/400x500/45B7D1/FFFFFF?text=Summer+Blouse'],
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
        id: 'formal-business-shirt',
        name: 'Formal Business Shirt',
        description: 'A professional business shirt perfect for office wear. Made with premium cotton blend.',
        price: 129.99,
        imageUrl: 'https://via.placeholder.com/400x500/96CEB4/FFFFFF?text=Business+Shirt',
        images: ['https://via.placeholder.com/400x500/96CEB4/FFFFFF?text=Business+Shirt'],
        category: 'Tops',
        tags: ['shirt', 'formal', 'business', 'office', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 18,
        rating: 4.6,
        reviewCount: 15,
        specifications: {
          'Material': 'Cotton Blend',
          'Care': 'Dry Clean Only',
          'Fit': 'Regular Fit',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      // Bottoms
      ProductModel(
        id: 'elegant-trousers',
        name: 'Elegant Trousers',
        description: 'Sophisticated trousers perfect for professional settings. Made with premium wool blend.',
        price: 159.99,
        imageUrl: 'https://via.placeholder.com/400x500/FFEAA7/666666?text=Elegant+Trousers',
        images: ['https://via.placeholder.com/400x500/FFEAA7/666666?text=Elegant+Trousers'],
        category: 'Bottoms',
        tags: ['trousers', 'formal', 'professional', 'wool', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 12,
        rating: 4.7,
        reviewCount: 20,
        specifications: {
          'Material': 'Wool Blend',
          'Care': 'Dry Clean Only',
          'Fit': 'Regular Fit',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: 'casual-jeans',
        name: 'Casual Jeans',
        description: 'Comfortable and stylish jeans perfect for everyday wear. Made with premium denim.',
        price: 99.99,
        imageUrl: 'https://via.placeholder.com/400x500/DDA0DD/FFFFFF?text=Casual+Jeans',
        images: ['https://via.placeholder.com/400x500/DDA0DD/FFFFFF?text=Casual+Jeans'],
        category: 'Bottoms',
        tags: ['jeans', 'casual', 'denim', 'everyday', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 30,
        rating: 4.4,
        reviewCount: 25,
        specifications: {
          'Material': 'Premium Denim',
          'Care': 'Machine Washable',
          'Fit': 'Slim Fit',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      // Accessories
      ProductModel(
        id: 'premium-silk-scarf',
        name: 'Premium Silk Scarf',
        description: 'A luxurious silk scarf with beautiful patterns. Perfect accessory for any outfit.',
        price: 59.99,
        imageUrl: 'https://via.placeholder.com/400x500/FFB6C1/FFFFFF?text=Silk+Scarf',
        images: ['https://via.placeholder.com/400x500/FFB6C1/FFFFFF?text=Silk+Scarf'],
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
      ProductModel(
        id: 'leather-handbag',
        name: 'Leather Handbag',
        description: 'A sophisticated leather handbag perfect for any occasion. Made with genuine leather.',
        price: 199.99,
        imageUrl: 'https://via.placeholder.com/400x500/8B4513/FFFFFF?text=Leather+Handbag',
        images: ['https://via.placeholder.com/400x500/8B4513/FFFFFF?text=Leather+Handbag'],
        category: 'Accessories',
        tags: ['handbag', 'leather', 'accessory', 'luxury', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 8,
        rating: 4.9,
        reviewCount: 28,
        specifications: {
          'Material': 'Genuine Leather',
          'Care': 'Leather Care Kit',
          'Dimensions': '30cm x 20cm x 10cm',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      // Suits
      ProductModel(
        id: 'business-suit',
        name: 'Professional Business Suit',
        description: 'A complete business suit perfect for professional settings. Made with premium wool blend.',
        price: 399.99,
        originalPrice: 499.99,
        imageUrl: 'https://via.placeholder.com/400x500/2F4F4F/FFFFFF?text=Business+Suit',
        images: ['https://via.placeholder.com/400x500/2F4F4F/FFFFFF?text=Business+Suit'],
        category: 'Suits',
        tags: ['suit', 'business', 'professional', 'formal', 'libas', 'collective'],
        isAvailable: true,
        stockQuantity: 10,
        rating: 4.8,
        reviewCount: 22,
        specifications: {
          'Material': 'Wool Blend',
          'Care': 'Dry Clean Only',
          'Fit': 'Regular Fit',
          'Includes': 'Jacket and Trousers',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Clear all products (for testing)
  Future<void> clearAllProducts() async {
    try {
      print('Clearing all products...');
      
      final products = await _productService.getAllProducts();
      int deletedCount = 0;
      
      for (final product in products) {
        try {
          await _productService.deleteProduct(product.id);
          deletedCount++;
        } catch (e) {
          print('Error deleting product ${product.name}: $e');
        }
      }
      
      print('Cleared $deletedCount products');
      
    } catch (e) {
      print('Error clearing products: $e');
    }
  }

  // Check if database has products
  Future<bool> hasProducts() async {
    try {
      final products = await _productService.getAllProducts();
      return products.isNotEmpty;
    } catch (e) {
      print('Error checking products: $e');
      return false;
    }
  }

  // Get product count
  Future<int> getProductCount() async {
    try {
      final products = await _productService.getAllProducts();
      return products.length;
    } catch (e) {
      print('Error getting product count: $e');
      return 0;
    }
  }
}
