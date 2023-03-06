// ignore_for_file: file_names, prefer_collection_literals

class FutSheetTop {
  String? diffRate;
  double? rate;
  int? bitcoinId;
  String? name;

  FutSheetTop({this.diffRate, this.rate, this.bitcoinId, this.name});

  FutSheetTop.fromJson(Map<String, dynamic> json) {
    diffRate = json['diffRate'];
    rate = json['rate'];
    bitcoinId = json['bitcoinId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['diffRate'] = diffRate;
    data['rate'] = rate;
    data['bitcoinId'] = bitcoinId;
    data['name'] = name;
    return data;
  }
}