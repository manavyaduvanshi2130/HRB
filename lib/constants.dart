import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const String dairyName = 'HRB DAIRY KHEDA RAMPURA';
  static const String ownerName = 'MAHESH KUMAR YADAV';
  static const String mobileNumber = '9983975591';
  static const String madeBy = 'MADE WITH ❤️ MADE WITH MANAV YADUVANSHI';

  static double rateConstantA = 8.0;
  static double rateConstantB = 2.0;

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rateConstantA = prefs.getDouble('rateConstantA') ?? 8.0;
    rateConstantB = prefs.getDouble('rateConstantB') ?? 2.0;
    _initialized = true;
  }

  static Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rateConstantA', rateConstantA);
    await prefs.setDouble('rateConstantB', rateConstantB);
  }

  // Default PDF page formats
  static const PdfPageFormat defaultPageFormat = PdfPageFormat.a4;
  static const double defaultTitleFontSize = 20.0;
  static const double defaultTableFontSize = 10.0;
  static const double minFontSize = 6.0;
  static const double maxFontSize = 16.0;

  // Available page formats
  static const Map<String, PdfPageFormat> pageFormats = {
    'A4': PdfPageFormat.a4,
    'A5': PdfPageFormat.a5,
    'Letter': PdfPageFormat.letter,
    'Legal': PdfPageFormat.legal,
  };
}
