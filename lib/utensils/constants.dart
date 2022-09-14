const appTITLE = "Information";
const onlineTimeOut = 5;

class KEYS {
  static const version = "version";
  static const images = "images";
  static const update = "appupdate";
  static const medicine = "medicines";
  static const doctor = "doctor";
  static const length = "length";
  static const data = "data";
}

extension StringExtention on String {
  String toTitle() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
