class Accessibility {

Accessibility(this.text, this.hint);

  /// Text for the accessibility
  String? text;

  /// Hint for the accessibility
  String? hint;

  @override
  String toString() {
    return 'Accessibility(text: $text, hint: $hint)';
  }
}
