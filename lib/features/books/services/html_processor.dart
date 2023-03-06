class HtmlProcessor{
  // Function to remove html tags from a string
  static String removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  //Function to check if it's string begins with HTTPS
  static bool isHttps(String url) {
    return url.startsWith('https');
  }

  static String removeNewLines(String text){
    RegExp newLines = RegExp('[\r\n]');

    return text.replaceAll(newLines, '');
  }

  static String removeTabs(String text){
    RegExp tabs = RegExp('[\t]');
    RegExp extraSpaces = RegExp('  +',multiLine: true);

    return text.replaceAll(tabs, ' ').replaceAll(extraSpaces, ' ');
  }

  // Capitalize the first letter
  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}