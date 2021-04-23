// class Instance {
//   DateTime dateFrom;
//   DateTime dateTo;
//   String product;
//   String storage;
//   int price;
//   String description;
//   bool isArchived;

//   Instance(this.dateFrom, this.dateTo, this.product, this.storage, this.price, this.description, this.isArchived);

//   Instance.fromJson(Map<String, dynamic> json) {
//     dateFrom = json['date_from'];
//     dateTo = json['date_to'];
//     product = json['product'];
//     storage = json['storage'];
//     price = json['price'];
//     description = json['description'];
//     isArchived = json['is_archived'];
//   }
// }

// To parse this JSON data, do
//
//     final instance = instanceFromJson(jsonString);

import 'dart:convert';

Instance instanceFromJson(String str) => Instance.fromJson(json.decode(str));

String instanceToJson(Instance data) => json.encode(data.toJson());

class Instance {
    Instance({
        this.id,
        this.dateTo,
        this.dateFrom,
        this.product,
        this.storage,
        this.price,
        this.description,
        this.isArchived,
    });

    int id;
    DateTime dateTo;
    DateTime dateFrom;
    String product;
    String storage;
    int price;
    String description;
    bool isArchived;

    factory Instance.fromJson(Map<String, dynamic> json) => Instance(
        id: json["id"],
        dateTo: DateTime.tryParse(json["date_to"]),
        dateFrom: DateTime.tryParse(json["date_from"]),
        product: json["product"],
        storage: json["storage"],
        price: json["price"],
        description: json["description"],
        isArchived: json["is_archived"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_to": "${dateTo.year.toString().padLeft(4, '0')}-${dateTo.month.toString().padLeft(2, '0')}-${dateTo.day.toString().padLeft(2, '0')}",
        "date_from": "${dateFrom.year.toString().padLeft(4, '0')}-${dateFrom.month.toString().padLeft(2, '0')}-${dateFrom.day.toString().padLeft(2, '0')}",
        "product": product,
        "storage": storage,
        "price": price,
        "description": description,
        "is_archived": isArchived,
    };
}
