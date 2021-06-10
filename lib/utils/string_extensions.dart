extension StringExtension on String {
  String capitalize() {
    return (this == null || this == "")? "": "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}