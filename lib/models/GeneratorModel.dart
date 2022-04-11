import 'dart:convert';

class Generator {
  Generator({
    required this.generatorId,
    required this.name,
    required this.ownerId,
    this.owner,
  });

  String generatorId;
  String name;
  String ownerId;
  dynamic owner;

  List<Generator> generatorFromJson(String str) =>
      List<Generator>.from(json.decode(str).map((x) => Generator.fromJson(x)));

  factory Generator.fromJson(Map<String, dynamic> json) => Generator(
        generatorId: json["generatorID"],
        name: json["name"],
        ownerId: json["ownerId"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "generatorID": generatorId,
        "name": name,
        "ownerId": ownerId,
        "owner": owner,
      };
}
