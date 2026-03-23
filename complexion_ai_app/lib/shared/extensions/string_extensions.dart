extension StringExt on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get titleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  String get snakeToTitle {
    return split('_').map((word) => word.capitalize).join(' ');
  }
}
