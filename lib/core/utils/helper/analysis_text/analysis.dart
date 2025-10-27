import 'package:finance_track/core/models/transactions_model.dart';

final Map<String, String> _categoryKeywords = {
  // 🍔 Food & Groceries
  'أكل': 'Food',
  'أكل بره': 'Food',
  'مطعم': 'Food',
  'طعام': 'Food',
  'وجبة': 'Food',
  'فطار': 'Food',
  'غدا': 'Food',
  'عشا': 'Food',
  'بقالة': 'Groceries',
  'سوبرماركت': 'Groceries',
  'عصير': 'Food',
  'كافيه': 'Food',
  'food': 'Food',
  'restaurant': 'Food',
  'meal': 'Food',
  'grocer': 'Groceries',
  'supermarket': 'Groceries',

  // 🚗 Transport
  'مواصلات': 'Transport',
  'تاكسي': 'Transport',
  'أوبر': 'Transport',
  'كريم': 'Transport',
  'بنزين': 'Transport',
  'وقود': 'Transport',
  'متر': 'Transport',
  'fuel': 'Transport',
  'transport': 'Transport',
  'uber': 'Transport',
  'bus': 'Transport',

  // 🏠 Home / Bills
  'إيجار': 'Home',
  'بيت': 'Home',
  'منزل': 'Home',
  'عقار': 'Home',
  'فاتورة': 'Bills & Utilities',
  'كهربا': 'Bills & Utilities',
  'مياه': 'Bills & Utilities',
  'نت': 'Bills & Utilities',
  'انترنت': 'Bills & Utilities',
  'تليفون': 'Bills & Utilities',
  'wifi': 'Bills & Utilities',
  'bill': 'Bills & Utilities',
  'electricity': 'Bills & Utilities',
  'internet': 'Bills & Utilities',
  'rent': 'Home',

  // 💊 Health
  'دواء': 'Health',
  'صيدلية': 'Health',
  'مستشفى': 'Health',
  'كشف': 'Health',
  'تحاليل': 'Health',
  'دكتور': 'Health',
  'hospital': 'Health',
  'medicine': 'Health',
  'pharmacy': 'Health',
  'clinic': 'Health',

  // 🎁 Gifts / Donations
  'هديه': 'Gifts',
  'هدية': 'Gifts',
  'عيد': 'Gifts',
  'تبرع': 'Donations',
  'صدقة': 'Donations',
  'gift': 'Gifts',
  'donation': 'Donations',

  // 🧾 Salary / Income
  'مرتب': 'Salary',
  'راتب': 'Salary',
  'قبض': 'Salary',
  'شغل': 'Salary',
  'دخل': 'Salary',
  'salary': 'Salary',
  'income': 'Salary',
  'bonus': 'Salary',
  'freelance': 'Freelance',
  'project': 'Freelance',

  // 💸 Shopping
  'لبس': 'Clothing',
  'هدوم': 'Clothing',
  'تيشيرت': 'Clothing',
  'بنطلون': 'Clothing',
  'موبايل': 'Gadgets',
  'جهاز': 'Gadgets',
  'إلكترونيات': 'Gadgets',
  'shopping': 'Shopping',
  'buy': 'Shopping',
  'purchase': 'Shopping',
  'gadget': 'Gadgets',

  // ✈️ Travel
  'سفر': 'Travel',
  'تذكرة': 'Travel',
  'طيارة': 'Travel',
  'hotel': 'Travel',
  'flight': 'Travel',
  'travel': 'Travel',

  // 🧠 Education
  'دروس': 'Education',
  'كورسات': 'Education',
  'مدرسة': 'Education',
  'جامعة': 'Education',
  'course': 'Education',
  'education': 'Education',
  'lesson': 'Education',

  // 📺 Subscriptions
  'اشتراك': 'Subscriptions',
  'نتفليكس': 'Subscriptions',
  'spotify': 'Subscriptions',
  'apple music': 'Subscriptions',
  'subscription': 'Subscriptions',

  // 🛡️ Insurance / Taxes
  'تأمين': 'Insurance',
  'insurance': 'Insurance',
  'ضريبة': 'Taxes',
  'ضرائب': 'Taxes',
  'tax': 'Taxes',
  'taxes': 'Taxes',

  // 💅 Beauty
  'صالون': 'Beauty & Care',
  'كوافير': 'Beauty & Care',
  'تجميل': 'Beauty & Care',
  'ميك اب': 'Beauty & Care',
  'makeup': 'Beauty & Care',
  'beauty': 'Beauty & Care',

  // 🐶 Pets
  'كلب': 'Pets',
  'قطة': 'Pets',
  'حيوان': 'Pets',
  'pet': 'Pets',

  // 🎮 Entertainment
  'سينما': 'Entertainment',
  'فيلم': 'Entertainment',
  'العاب': 'Entertainment',
  'لعب': 'Entertainment',
  'game': 'Entertainment',
  'entertainment': 'Entertainment',

  // 🪙 Other
  'بيع': 'Sales',
  'بيعت': 'Sales',
  'misc': 'Other',
  'other': 'Other',
};

final List<String> _incomeKeywords = [
  // بالعربي/المصري
  'استلمت',
  'قبضت',
  'دخلت',
  'دخل',
  'مرتّب',
  'راتب',
  'مكافأة',
  'عائد',
  'فلوس جاية',
  'فلوس اتقبضت',
  'هدية',
  'أرباح',
  'اخدت',
  'كسبت',

  'win',
  'won',
  'winnings',
  'winning',
  'earnings',

  'take'
      'income',
  'salary',
  'received',
  'got',
  'bonus',
  'profit',
  'allowance',
  'refund',
  'gift',
];
final List<String> _expenseKeywords = [
  // 🗣️ مصري / عربي عامي
  'دفعت',
  'صرف',
  'صرفنا',
  'دفعتلك',
  'دفعتله',
  'اشتريت',
  'شريت',
  'جبت',
  'جبت حاجة',
  'شحن',
  'كرت',
  'فاتورة',
  'ايجار',
  'ايجاري',
  'بنزين',
  'وقود',
  'اكل',
  'شرب',
  'مطعم',
  'وجبة',
  'تاكل',
  'قهوة',
  'شاي',
  'حلويات',
  'سوبرماركت',
  'بقالة',
  'صيدلية',
  'دواء',
  'كشف',
  'مستشفى',
  'سفر',
  'تذكرة',
  'مشوار',
  'ميكروباص',
  'اوبر',
  'كريم',
  'هدية',
  'هدايا',
  'اشتراك',
  'نت',
  'انترنت',
  'كهربا',
  'مياه',
  'غاز',
  'تليفون',
  'تسوق',
  'شراء',
  'لبس',
  'هدوم',
  'كوتشي',
  'شنطة',
  'مكياج',
  'تجميل',
  'حلاقة',
  'صالون',
  'كوافير',
  'مدرسة',
  'دروس',
  'مصروف',
  'نقطة',
  'عزومة',
  'عشاء',
  'غداء',
  'فطار',
  'سكن',
  'بيت',
  'ايجار بيت',
  'نقل',
  'صيانة',
  'تصليح',
  'تأمين',
  'ضريبة',

  // 🌍 English
  'spend',
  'spent',
  'pay',
  'paid',
  'buy',
  'bought',
  'purchase',
  'bill',
  'expense',
  'food',
  'meal',
  'drink',
  'restaurant',
  'coffee',
  'tea',
  'groceries',
  'supermarket',
  'pharmacy',
  'medicine',
  'hospital',
  'doctor',
  'travel',
  'ticket',
  'uber',
  'careem',
  'gift',
  'subscription',
  'internet',
  'electricity',
  'water',
  'gas',
  'shopping',
  'clothes',
  'rent',
  'tax',
  'insurance',
  'repair',
  'maintenance',
  'haircut',
  'beauty',
  'school',
  'lesson',
  'fee',
  'home',
  'house',
  'fuel',
  'transport',
];
double? _extractAmount(String text) {
  if (text.trim().isEmpty) return null;

  // تحويل الأرقام العربية للإنجليزية
  const arabicToEnglish = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };
  arabicToEnglish.forEach((k, v) => text = text.replaceAll(k, v));

  // توحيد الرموز العشرية والفواصل
  text = text.replaceAll('٫', '.').replaceAll('٬', ',').toLowerCase().trim();

  // البحث عن الرقم
  final regex = RegExp(r'(?:(?:\d{1,3}(?:[.,]\d{3})+)|\d+)(?:[.,]\d+)?');
  final match = regex.firstMatch(text);
  if (match == null) return null;

  var raw = match.group(0)!;

  // تنظيف الرقم من الفواصل
  raw = raw.replaceAll(',', '').replaceAll(' ', '');
  double number = double.tryParse(raw.replaceAll(',', '')) ?? 0;

  // مضاعفات
  if (text.contains('ألف') || text.contains('k')) number *= 1000;
  if (text.contains('مليون') || text.contains('m')) number *= 1000000;
  if (text.contains('مليار') || text.contains('b')) number *= 1000000000;

  return number;
}

DateTime _extractDate(String text) {
  final lower = text.toLowerCase();
  final now = DateTime.now();

  // أيام مباشرة
  if (lower.contains('اليوم') || lower.contains('today')) return now;
  if (lower.contains('أمس') || lower.contains('yesterday')) {
    return now.subtract(Duration(days: 1));
  }
  if (lower.contains('غداً') ||
      lower.contains('غدا') ||
      lower.contains('tomorrow')) {
    return now.add(Duration(days: 1));
  }

  // الأسبوع القادم / الماضي
  if (lower.contains('الأسبوع القادم')) {
    return now.add(Duration(days: 7 - now.weekday + 1));
  }
  if (lower.contains('الأسبوع الماضي')) {
    return now.subtract(Duration(days: now.weekday + 6));
  }

  // الشهر القادم / السابق
  if (lower.contains('الشهر القادم')) {
    return DateTime(now.year, now.month + 1, 1);
  }
  if (lower.contains('الشهر اللي فات') || lower.contains('الشهر السابق')) {
    return DateTime(now.year, now.month - 1, 1);
  }

  // الشهرين القادمين / الشهرين السابقين
  if (lower.contains('الشهرين القادمين')) {
    return DateTime(now.year, now.month + 2, 1);
  }
  if (lower.contains('الشهرين اللي فاتوا') ||
      lower.contains('الشهرين السابقين')) {
    return DateTime(now.year, now.month - 2, 1);
  }

  // السنة القادمة / السابقة
  if (lower.contains('السنة القادمة')) return DateTime(now.year + 1, 1, 1);
  if (lower.contains('السنة اللي فاتت') || lower.contains('السنة السابقة')) {
    return DateTime(now.year - 1, 1, 1);
  }

  // آخر X أيام/أسابيع/شهور
  final recentRegex = RegExp(r'آخر (\d+) (أيام|أسابيع|شهور|months|weeks|days)');
  final recentMatch = recentRegex.firstMatch(lower);
  if (recentMatch != null) {
    final num = int.tryParse(recentMatch.group(1)!) ?? 1;
    final unit = recentMatch.group(2)!;
    if (unit.contains('يوم') || unit.contains('day')) {
      return now.subtract(Duration(days: num));
    }
    if (unit.contains('أسبوع') || unit.contains('week')) {
      return now.subtract(Duration(days: num * 7));
    }
    if (unit.contains('شهر') || unit.contains('month')) {
      return DateTime(now.year, now.month - num, now.day);
    }
  }

  // نمط dd/mm/yyyy أو dd-mm-yyyy أو yyyy-mm-dd
  final dateRegex = RegExp(
    r'(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})|(\d{4}[-/]\d{1,2}[-/]\d{1,2})',
  );
  final m = dateRegex.firstMatch(text);
  if (m != null) {
    final found = m.group(0)!;
    try {
      if (found.contains('/')) {
        final parts = found.split('/');
        if (parts[2].length == 2) parts[2] = '20${parts[2]}';
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else if (found.contains('-')) {
        final parts = found.split('-');
        if (parts[0].length == 4) {
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
  }

  // نمط "5 يوليو" أو "July 5"
  final monthNames = {
    'يناير': 1,
    'فبراير': 2,
    'مارس': 3,
    'أبريل': 4,
    'مايو': 5,
    'يونيو': 6,
    'يوليو': 7,
    'يوليوز': 7,
    'يول': 7,
    'أغسطس': 8,
    'اغسطس': 8,
    'أغشت': 8,
    'سبتمبر': 9,
    'أكتوبر': 10,
    'نوفمبر': 11,
    'ديسمبر': 12,
    'january': 1,
    'february': 2,
    'march': 3,
    'april': 4,
    'may': 5,
    'june': 6,
    'july': 7,
    'august': 8,
    'september': 9,
    'october': 10,
    'november': 11,
    'december': 12,
  };

  for (final mn in monthNames.keys) {
    final r = RegExp(r'(\d{1,2})\s+' + RegExp.escape(mn), caseSensitive: false);
    final mm = r.firstMatch(text);
    if (mm != null) {
      return DateTime(now.year, monthNames[mn]!, int.parse(mm.group(1)!));
    }

    final r2 = RegExp(
      RegExp.escape(mn) + r'\s+(\d{1,2})',
      caseSensitive: false,
    );
    final mm2 = r2.firstMatch(text);
    if (mm2 != null) {
      return DateTime(now.year, monthNames[mn]!, int.parse(mm2.group(1)!));
    }
  }

  // ضبط ضمن ±18 شهر
  final minDate = DateTime(now.year, now.month - 18, 1);
  final maxDate = DateTime(now.year, now.month + 18, 1);
  return now.isBefore(minDate)
      ? minDate
      : now.isAfter(maxDate)
      ? maxDate
      : now;
}

String _extractType(String text) {
  final lower = text.toLowerCase();
  for (final k in _incomeKeywords) {
    if (lower.contains(k)) return 'income';
  }
  for (final k in _expenseKeywords) {
    if (lower.contains(k)) return 'expense';
  }

  // heuristics
  for (final kw in _categoryKeywords.keys) {
    if (lower.contains(kw)) {
      final mapped = _categoryKeywords[kw]!;
      final expenseLike = [
        'Food',
        'Groceries',
        'Transport',
        'Shopping',
        'Entertainment',
        'Bills & Utilities',
        'Health',
      ];
      if (expenseLike.contains(mapped)) return 'expense';
      return 'income';
    }
  }
  return 'expense';
}

String? _extractCategoryName(String text) {
  final lower = text.toLowerCase();
  for (final kw in _categoryKeywords.keys) {
    if (lower.contains(kw)) return _categoryKeywords[kw];
  }
  return null;
}

String _extractTitle(String text) {
  var t = text;

  // إزالة الأرقام
  t = t.replaceAll(
    RegExp(r'(?:(?:\d{1,3}(?:[.,]\d{3})+)|\d+)(?:[.,]\d+)?'),
    '',
  );
  // إزالة كلمات الوقت
  t = t.replaceAll(
    RegExp(
      r'\b(اليوم|أمس|غداً|غدا|yesterday|today|tomorrow|الشهر القادم|الشهر السابق|الأسبوع الماضي|الأسبوع القادم)\b',
      caseSensitive: false,
    ),
    '',
  );
  // إزالة كلمات النوع والفئة
  for (final k in [
    ..._incomeKeywords,
    ..._expenseKeywords,
    ..._categoryKeywords.keys,
  ]) {
    t = t.replaceAll(RegExp(RegExp.escape(k), caseSensitive: false), '');
  }

  t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (t.isEmpty) return 'Transaction';
  final words = t.split(' ');
  return words.length > 3 ? words.sublist(0, 3).join(' ') : t;
}

TransactionModel? parseTransactionFromText(String rawText, String userId) {
  final text = rawText.trim();
  if (text.isEmpty) return null;

  final amount = _extractAmount(text);
  final type = _extractType(text);
  final categoryName = _extractCategoryName(text);
  final date = _extractDate(text);
  final title = _extractTitle(text);
  final note = text;

  final hasAmount = amount != null && amount > 0;
  final hasMeaningfulKeyword = [
    ..._incomeKeywords,
    ..._expenseKeywords,
    ..._categoryKeywords.keys,
  ].any((k) => text.toLowerCase().contains(k));

  if (!hasAmount && !hasMeaningfulKeyword) return null;
  final finalAmount = hasAmount ? amount : 0.0;

  return TransactionModel(
    userId: userId,
    title: title,
    categoryName: categoryName,
    amount: finalAmount,
    type: type,
    date: date,
    note: note,
    createdAt: DateTime.now(),
  );
}
