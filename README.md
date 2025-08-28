# 🛍️ Libas - Modern E-Commerce App

A feature-rich, modern e-commerce mobile application built with Flutter, featuring Firebase backend, Stripe payments, push notifications, and comprehensive user management.

## 📱 App Overview

**Libas** (meaning "Style" in Arabic) is a comprehensive e-commerce platform that provides users with a seamless shopping experience, from product discovery to secure checkout, with advanced features like real-time notifications, location-based services, and multi-language support.

## ✨ Key Features

### 🏠 **Core Shopping Experience**
- **Product Catalog**: Browse products by category, search functionality, and advanced filtering
- **Shopping Cart**: Add/remove items, quantity management, and cart persistence
- **Secure Checkout**: Stripe-powered payment processing with order confirmation
- **Order Management**: Track orders, view order history, and shipping updates

### 🔐 **Authentication & User Management**
- **Multi-Provider Auth**: Email/password and Google Sign-In support
- **User Profiles**: Editable profiles with avatar upload and personal information
- **Address Management**: Shipping address storage and management
- **Location Services**: GPS-based location capture for delivery optimization

### 🔔 **Smart Notifications**
- **Push Notifications**: Firebase Cloud Messaging (FCM) integration
- **Welcome Messages**: Automated welcome notifications for new users
- **Order Updates**: Real-time shipping and order status notifications
- **Promotional Alerts**: Targeted marketing notifications
- **Notification Preferences**: User-configurable notification settings

### ⭐ **Product Reviews & Ratings**
- **Post-Purchase Rating**: Rate products immediately after successful payment
- **Review System**: Text reviews with star ratings
- **Rating Aggregation**: Automatic calculation of product average ratings
- **Rating History**: Track user rating contributions

### 🌍 **Localization & Accessibility**
- **Multi-Language Support**: English and Arabic with RTL support
- **Dynamic Language Switching**: In-app language selection
- **Cultural Adaptation**: Region-specific content and formatting

### 💳 **Payment & Security**
- **Stripe Integration**: Secure payment processing with multiple card support
- **Payment Sheet**: Modern, user-friendly payment interface
- **Order Confirmation**: Immediate payment success feedback
- **Secure Transactions**: PCI-compliant payment handling

## 🏗️ Technical Architecture

### **Frontend (Flutter)**
- **Framework**: Flutter 3.9+ with Dart 3.9+
- **State Management**: Provider pattern for reactive state management
- **UI Components**: Custom Material Design 3 components
- **Navigation**: Bottom navigation with tab-based routing
- **Responsive Design**: Adaptive layouts for different screen sizes

### **Backend (Firebase)**
- **Authentication**: Firebase Auth with custom user profiles
- **Database**: Cloud Firestore for real-time data synchronization
- **Storage**: Firebase Storage for image and file management
- **Functions**: Cloud Functions for server-side logic
- **Messaging**: Firebase Cloud Messaging for push notifications

### **External Services**
- **Payments**: Stripe API for secure payment processing
- **Maps**: Google Maps integration for location services
- **Reviews**: In-app review system for app store ratings

## 📱 User Stories & Workflows

### **New User Onboarding**
1. **App Launch**: User opens app and sees splash screen
2. **Authentication**: User signs up with email/password or Google account
3. **Profile Setup**: User completes profile with personal information
4. **Location Permission**: App requests location access for better service
5. **Welcome Message**: User receives welcome notification after 2 minutes
6. **Product Discovery**: User explores product catalog and categories

### **Shopping Experience**
1. **Product Browsing**: User navigates through products with search and filters
2. **Product Details**: User views detailed product information and images
3. **Add to Cart**: User adds products to cart with size/color selection
4. **Cart Management**: User reviews cart, adjusts quantities, and proceeds to checkout
5. **Payment Process**: User completes secure payment via Stripe
6. **Order Confirmation**: User receives payment success confirmation
7. **Product Rating**: User rates purchased products immediately after payment

### **Post-Purchase**
1. **Order Tracking**: User monitors order status and shipping updates
2. **Push Notifications**: User receives real-time order updates
3. **Product Reviews**: User provides feedback on purchased items
4. **Order History**: User accesses complete order history

### **User Management**
1. **Profile Updates**: User modifies personal information and avatar
2. **Address Management**: User updates shipping addresses
3. **Notification Preferences**: User configures notification settings
4. **Language Selection**: User switches between English and Arabic

## 🗂️ Project Structure

```
libas/
├── android/                 # Android platform-specific code
├── ios/                    # iOS platform-specific code
├── lib/                    # Main Flutter application code
│   ├── l10n/              # Localization files (English & Arabic)
│   ├── main.dart          # App entry point and configuration
│   ├── models/            # Data models with JSON serialization
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   ├── cart_model.dart
│   │   ├── order_model.dart
│   │   └── notification_model.dart
│   ├── providers/         # State management providers
│   │   ├── auth_provider.dart
│   │   ├── cart_provider.dart
│   │   ├── product_provider.dart
│   │   ├── notification_provider.dart
│   │   ├── review_provider.dart
│   │   └── locale_provider.dart
│   ├── services/          # Business logic and external API calls
│   │   ├── firebase_service.dart
│   │   ├── stripe_service.dart
│   │   ├── notification_service.dart
│   │   ├── rating_service.dart
│   │   ├── location_service.dart
│   │   └── cloud_functions_service.dart
│   ├── screens/           # UI screens and pages
│   │   ├── auth/          # Authentication screens
│   │   ├── home/          # Main app screens
│   │   ├── products/      # Product-related screens
│   │   ├── cart/          # Shopping cart screens
│   │   ├── payment/       # Payment and checkout screens
│   │   ├── profile/       # User profile screens
│   │   └── settings/      # App settings screens
│   ├── widgets/           # Reusable UI components
│   │   ├── custom_button.dart
│   │   ├── product_card.dart
│   │   ├── cart_item_card.dart
│   │   └── notification_badge.dart
│   └── utils/             # Utility classes and constants
│       └── constants.dart
├── functions/              # Firebase Cloud Functions
│   ├── src/               # TypeScript source code
│   │   └── index.ts       # Cloud functions implementation
│   ├── package.json       # Node.js dependencies
│   └── tsconfig.json      # TypeScript configuration
├── assets/                 # Static assets
│   ├── images/            # App images and graphics
│   └── icons/             # App icons and logos
├── pubspec.yaml           # Flutter dependencies and configuration
├── firebase.json          # Firebase project configuration
└── README.md              # This documentation file
```

## 🔧 Setup & Installation

### **Prerequisites**
- Flutter SDK 3.9.0 or higher
- Dart SDK 3.9.0 or higher
- Android Studio / Xcode for platform-specific development
- Firebase project with enabled services
- Stripe account for payment processing
- Google Cloud project for Maps API

### **1. Clone the Repository**
```bash
git clone https://github.com/yourusername/libas.git
cd libas
```

### **2. Install Dependencies**
```bash
flutter pub get
```

### **3. Firebase Setup**
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication, Firestore, Storage, and Cloud Functions
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place them in `android/app/` and `ios/Runner/` respectively
5. Update `lib/firebase_options.dart` with your project configuration

### **4. Stripe Configuration**
1. Create a Stripe account at [Stripe Dashboard](https://dashboard.stripe.com/)
2. Get your publishable and secret keys
3. Update `lib/services/stripe_service.dart` with your keys

### **5. Google Maps Setup**
1. Enable Google Maps API in Google Cloud Console
2. Get API key and update platform-specific configurations

### **6. Cloud Functions Deployment**
```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

### **7. Run the Application**
```bash
flutter run
```

## 🚀 Deployment

### **Android Build**
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### **iOS Build**
```bash
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode for final build
```

### **Firebase Functions**
```bash
cd functions
npm run deploy
```

## 🔐 Environment Variables

Create a `.env` file in the root directory:
```env
STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
STRIPE_SECRET_KEY=sk_test_your_key_here
FIREBASE_PROJECT_ID=your-project-id
GOOGLE_MAPS_API_KEY=your_maps_api_key
```

## 📊 Data Models

### **User Model**
- Basic info (name, email, phone)
- Profile picture and preferences
- Shipping addresses
- Location coordinates
- FCM token for notifications

### **Product Model**
- Product details (name, description, price)
- Images and specifications
- Category and tags
- Stock information
- Rating and review count

### **Cart Model**
- User ID and items
- Quantity and variant selection
- Timestamps for cart management
- Total calculation methods

### **Order Model**
- Order details and status
- Payment information
- Shipping details
- Order history tracking

### **Notification Model**
- Notification content and type
- User targeting and delivery
- Read status and timestamps
- Action payloads

## 🔄 State Management

The app uses the **Provider pattern** for state management:

- **AuthProvider**: User authentication and profile management
- **CartProvider**: Shopping cart state and operations
- **ProductProvider**: Product catalog and filtering
- **NotificationProvider**: Push notification management
- **ReviewProvider**: Product rating and review system
- **LocaleProvider**: Language and localization settings

## 🔔 Notification System

### **Types of Notifications**
1. **Welcome Messages**: New user onboarding
2. **Order Updates**: Shipping and delivery status
3. **Promotional**: Marketing and offers
4. **System**: App updates and maintenance

### **Delivery Methods**
- **Push Notifications**: FCM for real-time delivery
- **Local Notifications**: Fallback for offline scenarios
- **In-App Notifications**: Notification center within the app

## 🌍 Localization

### **Supported Languages**
- **English**: Primary language with LTR layout
- **Arabic**: Secondary language with RTL layout support

### **Localization Features**
- Dynamic language switching
- RTL layout support for Arabic
- Culturally appropriate content
- Localized date and number formats

## 🧪 Testing

### **Unit Tests**
```bash
flutter test
```

### **Integration Tests**
```bash
flutter test integration_test/
```

### **Widget Tests**
```bash
flutter test test/widget_test.dart
```

## 📱 Platform Support

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **Web**: Flutter web support (experimental)
- **Desktop**: Windows, macOS, Linux (experimental)

## 🔒 Security Features

- **Authentication**: Firebase Auth with JWT tokens
- **Data Validation**: Input sanitization and validation
- **Secure Storage**: Encrypted local storage
- **API Security**: Firebase Security Rules
- **Payment Security**: Stripe PCI compliance

## 📈 Performance Optimizations

- **Image Caching**: Cached network images for faster loading
- **Lazy Loading**: On-demand data loading
- **State Persistence**: Efficient state management
- **Background Processing**: Optimized notification handling
- **Memory Management**: Proper resource cleanup

## 🐛 Troubleshooting

### **Common Issues**

1. **Firebase Connection Issues**
   - Verify Firebase configuration files
   - Check internet connectivity
   - Validate Firebase project settings

2. **Stripe Payment Failures**
   - Verify Stripe API keys
   - Check test card numbers
   - Validate payment sheet configuration

3. **Notification Issues**
   - Check FCM token generation
   - Verify notification permissions
   - Check Cloud Functions deployment

4. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Verify platform-specific configurations
   - Check dependency versions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- **Email**: mohammedaliedriis@gmail.com
- **Issues**: [GitHub Issues](https://github.com/Ki11ay/libas/issues)
