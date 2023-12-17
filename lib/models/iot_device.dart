// ignore_for_file: camel_case_types

class IoT_Device {
  String name;
  String imagePath;
  int uuid;
  bool state;

  IoT_Device({
    required this.name,
    required this.imagePath,
    required this.uuid,
    required this.state,
  });

  String get _name => name;
  String get _imagePath => imagePath;
  int get _uuid => uuid;
  bool get _state => state;
}
