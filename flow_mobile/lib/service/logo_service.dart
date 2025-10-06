import 'package:flow_mobile/domain/entity/bank.dart';

class LogoService {
  String getLogoUrl(String brandDomain) {
    return generateLogoSearchUrl(brandDomain);
  }

  String getCategoryIcon(String category, bool isDark) {
    return "assets/icons/category_icons/${category.toLowerCase()}${isDark ? '_dark' : '_dark'}.png";
  }

  String getBankLogoUri(Bank bank) {
    return "assets/bank_logos/${bank.name.toUpperCase()}.png";
  }

  String getBankLogouri(String bankName) {
    return "assets/bank_logos/${bankName.toUpperCase()}.png";
  }

  String generateLogoSearchUrl(String brandDomain) {
    String url =
        "https://cdn.brandfetch.io/$brandDomain/fallback/404?c=1idZKCCEynU5Tej88f8";
    return url;
  }
}
