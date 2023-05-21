class ParseVideoId {
  String extractVideoIdFromUrl(String url) {
    var regExp = RegExp(
        r'^(?:https?:\/\/)?(?:www\.|m\.)?youtube\.com\/watch\?v=([^\s&]+)');
    var match = regExp.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? '';
    } else {
      return '';
    }
  }
}
