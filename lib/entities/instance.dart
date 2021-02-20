class Instance {
  String dateFrom;
  String dateTo;
  String product;
  String storage;
  String price;
  String description;

  Instance(this.product, this.storage, this.price, this.description);

  Instance.fromJson(Map<String, dynamic> json) {
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    product = json['product'];
    storage = json['storage'];
    price = json['price'].toString();
    description = json['description'];
  }
}