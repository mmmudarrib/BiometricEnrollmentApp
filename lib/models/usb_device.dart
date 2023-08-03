class USBDeviceModel {
  int? vid;
  String? manufacturerName;
  int? interfaceCount;
  int? pid;
  String? deviceName;
  int? deviceId;
  String? productName;

  USBDeviceModel(
      {this.vid,
      this.manufacturerName,
      this.interfaceCount,
      this.pid,
      this.deviceName,
      this.deviceId,
      this.productName});

  USBDeviceModel.fromJson(Map<String, dynamic> json) {
    vid = json['vid'];
    manufacturerName = json['manufacturerName'];
    interfaceCount = json['interfaceCount'];
    pid = json['pid'];
    deviceName = json['deviceName'];
    deviceId = json['deviceId'];
    productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vid'] = vid;
    data['manufacturerName'] = manufacturerName;
    data['interfaceCount'] = interfaceCount;
    data['pid'] = pid;
    data['deviceName'] = deviceName;
    data['deviceId'] = deviceId;
    data['productName'] = productName;
    return data;
  }
}
