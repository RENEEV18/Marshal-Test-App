class HelperFunction {
  // Function to check the null and empty string value.
  static String checkValue(String? value) {
    if (value == null || value.isEmpty || value == 'null' || value == 'Null') {
      return 'No data';
    } else {
      return value;
    }
  }
}
