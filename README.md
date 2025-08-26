# Libas - Modern E-Commerce App

A beautiful, modern e-commerce mobile application built with Flutter, featuring Firebase backend services and Stripe payment integration. The app follows iOS 26 design principles and provides a seamless shopping experience.

## 🚀 Features

### Core Functionality
- **User Authentication**: Email/password and Google Sign-In support
- **Product Management**: Browse, search, and filter products by category
- **Shopping Cart**: Add, remove, and manage cart items
- **User Profiles**: View and edit personal information
- **Order Management**: Track order status and history

### Advanced Features
- **Real-time Search**: Search products by name, description, and tags
- **Image Caching**: Efficient product image loading with cached_network_image
- **Push Notifications**: Firebase Cloud Messaging integration
- **Payment Processing**: Stripe integration for secure payments
- **Maps Integration**: Google Maps for location services
- **Image Editing**: Profile picture cropping and editing
- **In-App Reviews**: User review system

### Design & UX
- **Modern UI**: iOS 26 inspired design with Material 3
- **Responsive Layout**: Adaptive design for different screen sizes
- **Smooth Animations**: Beautiful transitions and micro-interactions
- **Dark/Light Theme**: Theme switching support
- **Localization**: Multi-language support with intl package

## 🛠 Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile development framework
- **Provider**: State management solution
- **Material Design**: UI component library

### Backend Services
- **Firebase Authentication**: User authentication and management
- **Cloud Firestore**: NoSQL database for data storage
- **Firebase Storage**: File and image storage
- **Firebase Messaging**: Push notifications

### Payment & External Services
- **Stripe**: Payment processing and checkout
- **Google Maps**: Location and mapping services
- **Google Sign-In**: Social authentication

### Development Tools
- **JSON Serialization**: Automatic JSON parsing with build_runner
- **Code Generation**: Automated code generation for models
- **Linting**: Flutter lints for code quality

## 📱 Screenshots

[Add screenshots here when available]

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.9.0 or higher)
- Android Studio / VS Code
- Firebase project setup
- Stripe account (for payments)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/libas.git
   cd libas
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication, Firestore, Storage, and Messaging
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders

4. **Stripe Setup**
   - Create a Stripe account
   - Get your publishable and secret keys
   - Update the keys in `lib/services/stripe_service.dart`

5. **Google Sign-In Setup**
   - Configure OAuth 2.0 in Firebase Console
   - Add SHA-1 fingerprint for Android
   - Update iOS bundle identifier

6. **Run the app**
   ```bash
   flutter run
   ```

### Environment Configuration

Create a `.env` file in the root directory:
```env
STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
STRIPE_SECRET_KEY=sk_test_your_key_here
FIREBASE_PROJECT_ID=your_project_id
```

## 🏗 Project Structure

```
lib/
├── models/           # Data models with JSON serialization
├── providers/        # State management providers
├── screens/          # App screens and pages
│   ├── auth/        # Authentication screens
│   ├── home/        # Main app screens
│   ├── product/     # Product-related screens
│   ├── cart/        # Shopping cart screens
│   ├── profile/     # User profile screens
│   └── search/      # Search functionality
├── services/         # Business logic and API services
├── utils/           # Constants, helpers, and utilities
└── widgets/         # Reusable UI components
```

## 🔧 Configuration

### Firebase Configuration
1. Enable required services in Firebase Console
2. Set up Firestore security rules
3. Configure Storage rules for image uploads
4. Set up Authentication providers

### Stripe Configuration
1. Create webhook endpoints
2. Configure payment methods
3. Set up customer management
4. Test with test cards

### Platform-Specific Setup

#### Android
- Update `android/app/build.gradle.kts`
- Configure signing for release builds
- Set up ProGuard rules

#### iOS
- Update `ios/Runner/Info.plist`
- Configure signing and capabilities
- Set up URL schemes for deep linking

## 📊 Database Schema

### Collections

#### Users
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoURL": "https://...",
  "phoneNumber": "+1234567890",
  "address": "123 Main St",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z",
  "isEmailVerified": true,
  "favoriteProducts": ["product_id_1", "product_id_2"],
  "preferences": {}
}
```

#### Products
```json
{
  "id": "product_id",
  "name": "Product Name",
  "description": "Product description",
  "price": 99.99,
  "originalPrice": 129.99,
  "images": ["https://...", "https://..."],
  "category": "Electronics",
  "tags": ["wireless", "bluetooth"],
  "stockQuantity": 50,
  "rating": 4.5,
  "reviewCount": 25,
  "isAvailable": true,
  "isFeatured": false,
  "specifications": {},
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

#### Carts
```json
{
  "id": "cart_id",
  "userId": "user_id",
  "items": [
    {
      "id": "item_id",
      "productId": "product_id",
      "productName": "Product Name",
      "productImage": "https://...",
      "price": 99.99,
      "quantity": 2,
      "addedAt": "2024-01-01T00:00:00Z"
    }
  ],
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

#### Orders
```json
{
  "id": "order_id",
  "userId": "user_id",
  "items": [...],
  "totalAmount": 199.98,
  "status": "pending",
  "trackingNumber": "TRK123456",
  "notes": "Delivery instructions",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z",
  "estimatedDelivery": "2024-01-05T00:00:00Z",
  "shippingAddress": "123 Main St",
  "paymentMethod": "card",
  "stripePaymentIntentId": "pi_..."
}
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/
```

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS Archive
```bash
flutter build ios --release
```

## 🔒 Security Considerations

- Firebase Security Rules for data access control
- Input validation and sanitization
- Secure API key management
- HTTPS for all network requests
- User authentication and authorization
- Data encryption in transit and at rest

## 🚀 Deployment

### Firebase Hosting (Web)
```bash
flutter build web
firebase deploy
```

### App Store Deployment
1. Build release versions
2. Test thoroughly on devices
3. Submit to App Store Connect
4. Submit to Google Play Console

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Code Style
- Follow Flutter/Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Stripe for payment processing
- The open-source community for various packages

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔄 Changelog

### Version 1.0.0
- Initial release
- Core e-commerce functionality
- Firebase integration
- Stripe payment processing
- Modern UI/UX design

---

**Note**: This is a development version. Some features may be in progress or require additional configuration.
