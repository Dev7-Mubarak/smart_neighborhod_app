class StatisticsModel {
  late SocialAndFamily socialAndFamily;
  late Agreements agreements;
  late Projects projects;
  late Teams teams;
  late PopulationStatus populationStatus;
  late IncomeCategories incomeCategories;
  late Health health;
  late Housing housing;

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    socialAndFamily = SocialAndFamily.fromJson(json['socialAndFamily'] ?? {});
    agreements = Agreements.fromJson(json['agreements'] ?? {});
    projects = Projects.fromJson(json['projects'] ?? {});
    teams = Teams.fromJson(json['teams'] ?? {});
    populationStatus = PopulationStatus.fromJson(
      json['populationStatus'] ?? {},
    );
    incomeCategories = IncomeCategories.fromJson(
      json['incomeCategories'] ?? {},
    );
    health = Health.fromJson(json['health'] ?? {});
    housing = Housing.fromJson(json['housing'] ?? {});
  }
}

class SocialAndFamily {
  late int divorced;
  late int widows;
  late int families;
  late int individuals;

  SocialAndFamily.fromJson(Map<String, dynamic> json) {
    divorced = json['divorced'] ?? 0;
    widows = json['widows'] ?? 0;
    families = json['families'] ?? 0;
    individuals = json['individuals'] ?? 0;
  }
}

class Agreements {
  late int completed;
  late int notCompleted;
  late int peaceCompleted;
  late int peaceNotCompleted;
  late int treatiesCompleted;
  late int treatiesNotCompleted;
  late int agreementsCompleted;
  late int agreementsNotCompleted;

  Agreements.fromJson(Map<String, dynamic> json) {
    completed = json['completed'] ?? 0;
    notCompleted = json['notCompleted'] ?? 0;
    peaceCompleted = json['peaceCompleted'] ?? 0;
    peaceNotCompleted = json['peaceNotCompleted'] ?? 0;
    treatiesCompleted = json['treatiesCompleted'] ?? 0;
    treatiesNotCompleted = json['treatiesNotCompleted'] ?? 0;
    agreementsCompleted = json['agreementsCompleted'] ?? 0;
    agreementsNotCompleted = json['agreementsNotCompleted'] ?? 0;
  }
}

class Projects {
  late int completed;
  late int incomplete;

  Projects.fromJson(Map<String, dynamic> json) {
    completed = json['completed'] ?? 0;
    incomplete = json['incomplete'] ?? 0;
  }
}

class Teams {
  late int teamsCount;

  Teams.fromJson(Map<String, dynamic> json) {
    teamsCount = json['teamsCount'] ?? 0;
  }
}

class PopulationStatus {
  late int residents;
  late int displaced;

  PopulationStatus.fromJson(Map<String, dynamic> json) {
    residents = json['residents'] ?? 0;
    displaced = json['displaced'] ?? 0;
  }
}

class IncomeCategories {
  late int categoryA;
  late int categoryB;
  late int categoryC;

  IncomeCategories.fromJson(Map<String, dynamic> json) {
    categoryA = json['categoryA'] ?? 0;
    categoryB = json['categoryB'] ?? 0;
    categoryC = json['categoryC'] ?? 0;
  }
}

class Health {
  late int individualsWithChronicDiseases;

  Health.fromJson(Map<String, dynamic> json) {
    individualsWithChronicDiseases =
        json['individualsWithChronicDiseases'] ?? 0;
  }
}

class Housing {
  late int rented;
  late int owned;

  Housing.fromJson(Map<String, dynamic> json) {
    rented = json['rented'] ?? 0;
    owned = json['owned'] ?? 0;
  }
}
