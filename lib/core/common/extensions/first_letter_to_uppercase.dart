extension FirstLettersToUppercase on String {
  String firstLettersToUppercase() {
    List<String> words = split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].trim().length > 1) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }
}
