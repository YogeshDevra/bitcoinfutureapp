// ignore_for_file: file_names, prefer_collection_literals

class TopCoinData {
  String? diffRate;
  double? rate;
  int? bitcoinId;
  String? name;

  TopCoinData({this.diffRate, this.rate, this.bitcoinId, this.name});

  TopCoinData.fromJson(Map<String, dynamic> json) {
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