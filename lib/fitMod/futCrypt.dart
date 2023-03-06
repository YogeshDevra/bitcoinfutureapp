// ignore_for_file: file_names

class FutCrypto {
  final int? id;
  final String? name;
  final double? rate;
  final String? diffRate;
  final List<dynamic>? historyRate;
  final String? date;
  final String? perRate;

  // All dogs start out at 10, because they're good dogs.

  FutCrypto(
      {this.id,
        this.name,
        this.rate,
        this.date,
        this.diffRate,
        this.historyRate,
        this.perRate});
  factory FutCrypto.fromJson(Map<String, dynamic> json) {
    return FutCrypto(
      id: json["id"],
      name: json["name"],
      rate: json["rate"],
      date: json["date"],
      diffRate: json["diffRate"],
      historyRate: json["historyRate"],
      perRate: json["perRate"],
    );
  }
}
