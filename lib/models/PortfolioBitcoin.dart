// ignore_for_file: file_names

class PortfolioBitcoin {
  int? _id;
  String? _name;
  double? _rate;
  double? _rateDuringAdding;
  double? _numberOfCoins;
  double? _totalValue;


  PortfolioBitcoin(this._id, this._name, this._rate, this._rateDuringAdding,
      this._numberOfCoins, this._totalValue);

  int get id => _id!;

  String get name => _name!;

  double get rate => _rate!;

  double get rateDuringAdding => _rateDuringAdding!;

  double get numberOfCoins => _numberOfCoins!;

  double get totalValue => _totalValue!;

  PortfolioBitcoin.map(dynamic obj) {
    _id = obj['id'];
    _name=obj['name'] ;
    _rate =  obj['rate'];
    _rateDuringAdding= obj['rate_during_adding'] ;
    _numberOfCoins = obj['coins_quantity'];
    _totalValue= obj['total_value'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['rate'] = _rate;
    map['rate_during_adding'] = _rateDuringAdding;
    map['coins_quantity'] = _numberOfCoins;
    map['total_value'] = _numberOfCoins;

    return map;
  }

  PortfolioBitcoin.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name=map['name'] ;
    _rate =  map['rate'];
    _rateDuringAdding= map['rate_during_adding'] ;
    _numberOfCoins = map['coins_quantity'] ;
    _totalValue= map['total_value'];
  }
// All dogs start out at 10, because they're good dogs.




}
