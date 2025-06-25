class ReconciliationCouncil{
  late String Supervisor;
  late String tital;
  late DateTime Session_Date;
  late String Session_Output;
  late String Notes;
  late String Image_link;
  late bool Treaty_Done;
  late List<List> First_party;
  late List<List> Second_party;
  late List<List> Witnesses;
  
  ReconciliationCouncil({required this.First_party,required this.Image_link,required this.Notes,required this.Second_party,required this.Session_Date,required this.Session_Output,required this.Supervisor,required this.Treaty_Done,required this.Witnesses,required this.tital});
  // ReconciliationCouncil.fromJson(Map<String, dynamic> json) {
  // Supervisor=json["AssistType"];
  // tital=json["deliverDate"];
  // Notes=json["Notes"];
  // }

}