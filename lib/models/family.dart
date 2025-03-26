class Family{
   late int id;
  late String name;
  late String Familyfather;
  late String familyCategory;
  late String hosingType;
  late String phoneNumber;
  late String location;
  late String familyType;
  late String familyNotes;
  late int blockId;
  Family.fromJson(Map<String, dynamic> json) {
  id=json["id"];
  phoneNumber=json["phoneNumber"];
  name=json["name"];
  Familyfather=json["Familyfather"];
  familyCategory=json["familyCategory"];
  hosingType=json["hosingType"];
  location=json["location"];
  familyType=json["familyType"];
  familyNotes=json["familyNotes"];
  blockId=json["blockId"];
  } 
}