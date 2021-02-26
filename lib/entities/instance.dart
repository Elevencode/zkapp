class Instance {
  String dateFrom;
  String dateTo;
  String product;
  String storage;
  String price;
  String description;
  bool isArchived;

  Instance(this.dateFrom, this.dateTo, this.product, this.storage, this.price, this.description, this.isArchived);

  Instance.fromJson(Map<String, dynamic> json) {
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    product = json['product'];
    storage = json['storage'];
    price = json['price'].toString();
    description = json['description'];
    isArchived = json['is_archived'];
  }
}