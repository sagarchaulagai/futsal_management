import 'dart:convert';

import 'package:http/http.dart' as http;

class BaserowApi {
  final String base = "https://api.baserow.io/api/";
  final String token = "Token 6fY0I0LmZxuUKSTjyjDfZiH5ivEzFG55";

  Future<List<FutsalTimingData>> getFutsalTimings(int tableId) async {
    String remUrl = "database/rows/table/$tableId/";
    var url = Uri.parse(base + remUrl);
    var response = await http.get(url, headers: {"Authorization": token});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print(data["results"][0]);
      return FutsalTimingData.fromJsonList(data["results"]);
    } else {
      return [];
    }
  }

  Future<String> postFutsalTimings(
    int tableId,
    DateTime date,
    bool status,
    String paymentBy,
    int phoneNo,
  ) async {
    String remUrl = "database/rows/table/$tableId/?user_field_names=true";
    var url = Uri.parse(base + remUrl);
    var jsonData = FutsalDatabase(
      duration: date,
      status: status,
      paymentBy: paymentBy,
      phoneNo: phoneNo.toString(),
    ).toJson();

    var response = await http.post(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jsonData),
    );
    return response.body;
  }
}

class FutsalDatabase {
  DateTime duration;
  bool status;
  String paymentBy;
  String phoneNo;

  FutsalDatabase({
    required this.duration,
    required this.status,
    required this.paymentBy,
    required this.phoneNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'Duration': duration.toUtc().toIso8601String(),
      'Status': status,
      'PaymentBy': paymentBy,
      'PhoneNo': phoneNo,
    };
  }
}

class FutsalTimingData {
  final int? id;
  final DateTime? date;
  final bool? status;
  final String? name;
  final String? phoneNo;

  FutsalTimingData.fromJson(Map json)
      : id = json["id"],
        date = DateTime.parse(json["field_1708583"]),
        status = json["field_1708587"],
        name = json["field_1710393"],
        phoneNo = json["field_1710394"].toString();

  static List<FutsalTimingData> fromJsonList(List list) {
    List<FutsalTimingData> output = [];
    for (var item in list) {
      output.add(FutsalTimingData.fromJson(item));
    }
    return output;
  }
}
