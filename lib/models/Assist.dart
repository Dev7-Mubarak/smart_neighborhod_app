class Assist{
  late String AssistType;
  late DateTime deliverDate;
  late String Notes;
  
  Assist.fromJson(Map<String, dynamic> json) {
  AssistType=json["AssistType"];
  deliverDate=json["deliverDate"];
  Notes=json["Notes"];
  }
}