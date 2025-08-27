// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'لباس';

  @override
  String get appTagline => 'اكتشف أسلوبك';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get continueWithGoogle => 'المتابعة مع جوجل';

  @override
  String get home => 'الرئيسية';

  @override
  String get search => 'البحث';

  @override
  String get products => 'المنتجات';

  @override
  String get cart => 'عربة التسوق';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get orders => 'الطلبات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get addToCart => 'أضف إلى عربة التسوق';

  @override
  String get buyNow => 'اشتر الآن';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get inStock => 'متوفر';

  @override
  String get freeShipping => 'شحن مجاني';

  @override
  String get cartEmpty => 'عربة التسوق فارغة';

  @override
  String get cartEmptySubtitle => 'أضف بعض المنتجات للبدء';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get total => 'المجموع';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get shipping => 'الشحن';

  @override
  String get tax => 'الضريبة';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get personalInfo => 'المعلومات الشخصية';

  @override
  String get shippingAddress => 'عنوان الشحن';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get help => 'المساعدة والدعم';

  @override
  String get about => 'حول';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get done => 'تم';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get quantity => 'الكمية';

  @override
  String get description => 'الوصف';

  @override
  String get category => 'الفئة';

  @override
  String get rating => 'التقييم';

  @override
  String get tags => 'العلامات';

  @override
  String get stockStatus => 'حالة المخزون';

  @override
  String get available => 'متوفر';

  @override
  String get unavailable => 'غير متوفر';

  @override
  String get locationPermissionRequired => 'مطلوب إذن الموقع لتقديم خدمة أفضل';

  @override
  String get locationServicesDisabled => 'خدمات الموقع معطلة';

  @override
  String get gettingLocation => 'جاري الحصول على موقعك...';

  @override
  String locationCaptured(Object latitude, Object longitude) {
    return 'تم التقاط الموقع: $latitude, $longitude';
  }

  @override
  String get locationError => 'خطأ في الحصول على الموقع';

  @override
  String get searchProducts => 'البحث في المنتجات...';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get newest => 'الأحدث';

  @override
  String get priceLowToHigh => 'السعر: من الأقل إلى الأعلى';

  @override
  String get priceHighToLow => 'السعر: من الأعلى إلى الأقل';

  @override
  String get highestRated => 'الأعلى تقييماً';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get tryAdjustingFilters => 'حاول تعديل البحث أو الفلاتر';

  @override
  String get errorLoadingProducts => 'خطأ في تحميل المنتجات';

  @override
  String get retryLoading => 'إعادة المحاولة';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get welcome => 'مرحباً بك في لباس';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get locationUpdated => 'تم تحديث الموقع بنجاح';

  @override
  String get language => 'اللغة';

  @override
  String get languageSelection => 'يرجى اختيار لغتك المفضلة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get updateLocation => 'تحديث الموقع';

  @override
  String get refreshLocation => 'تحديث موقعك الحالي';

  @override
  String get updatingLocation => 'جاري تحديث الموقع...';

  @override
  String get locationUpdateSuccess => 'تم تحديث الموقع بنجاح!';

  @override
  String get locationUpdateFailed => 'فشل في تحديث الموقع. يرجى التحقق من الأذونات.';

  @override
  String locationUpdateError(Object error) {
    return 'فشل في تحديث الموقع: $error';
  }

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع';

  @override
  String get locationCaptureFailed => 'فشل في الحصول على بيانات الموقع';

  @override
  String get locationDataSaved => 'تم حفظ بيانات الموقع في Firebase بنجاح';

  @override
  String locationCaptureError(Object error) {
    return 'خطأ في التقاط وحفظ الموقع: $error';
  }

  @override
  String refreshingLocation(Object userId) {
    return 'جاري تحديث الموقع للمستخدم الحالي: $userId';
  }

  @override
  String refreshingLocationError(Object error) {
    return 'خطأ في تحديث موقع المستخدم: $error';
  }

  @override
  String checkingLocationData(Object error) {
    return 'خطأ في التحقق من بيانات الموقع: $error';
  }

  @override
  String startingLocationCapture(Object userId) {
    return 'بدء التقاط الموقع للمستخدم: $userId';
  }

  @override
  String updatingUserProfile(Object data) {
    return 'جاري تحديث ملف المستخدم بالبيانات: $data';
  }

  @override
  String get userProfileUpdateSuccess => 'تم تحديث ملف المستخدم بنجاح';

  @override
  String userProfileUpdateError(Object error) {
    return 'فشل في تحديث ملف المستخدم: $error';
  }

  @override
  String get signOutConfirmation => 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

  @override
  String languageChanged(Object language) {
    return 'تم تغيير اللغة إلى $language';
  }

  @override
  String get pleaseSignInToViewProfile => 'يرجى تسجيل الدخول لعرض ملفك الشخصي';

  @override
  String get user => 'المستخدم';

  @override
  String get viewOrderHistory => 'عرض سجل الطلبات';

  @override
  String get savedProducts => 'المنتجات المحفوظة';

  @override
  String get manageDeliveryAddresses => 'إدارة عناوين التوصيل';

  @override
  String get savedPaymentMethods => 'طرق الدفع المحفوظة';

  @override
  String get manageNotificationPreferences => 'إدارة تفضيلات الإشعارات';

  @override
  String get privacyAndSecuritySettings => 'إعدادات الخصوصية والأمان';

  @override
  String get getHelpAndSupport => 'الحصول على المساعدة والدعم';

  @override
  String get appInformationAndVersion => 'معلومات التطبيق والإصدار';
}
