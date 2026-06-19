import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/api_service.dart';
import '../models/dev_tip.dart';

// Récupère un tip dev depuis l'API (avec fallback local)
final quoteProvider = FutureProvider<DevTip>((ref) async {
  return ApiService.fetchDevTip();
});
