import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GnMatch {
  final String id;
  final String tour;
  final String teamA;
  final String codeA;
  final String teamB;
  final String codeB;
  final String date;
  final String time;
  final String? score;
  final String stadium;
  final String status;
  final String summary;

  const GnMatch({
    required this.id,
    required this.tour,
    required this.teamA,
    required this.codeA,
    required this.teamB,
    required this.codeB,
    required this.date,
    required this.time,
    this.score,
    required this.stadium,
    required this.status,
    required this.summary,
  });

  bool get isFinished => score != null || status == 'Terminé';
}

class GnMatchService with ChangeNotifier {
  static final GnMatchService _instance = GnMatchService._internal();
  factory GnMatchService() => _instance;
  GnMatchService._internal();

  final Set<String> _favMatchIds = {'m_1', 'm_2'};
  String _userName = 'Supporter Guinée';
  String _favoriteTeam = 'Horoya AC';

  Set<String> get favMatchIds => Set.unmodifiable(_favMatchIds);
  String get userName => _userName;
  String get favoriteTeam => _favoriteTeam;

  final List<String> teams = const [
    'Horoya AC',
    'Hafia FC',
    'AS Kaloum',
    'CI Kamsar',
    'Satellite FC',
    'Milo FC Kankan',
    'Wakriya AC',
    'Flamme Olympique',
    'Renaissance FC',
    'Ashanti Golden Boys',
  ];

  final List<GnMatch> matches = const [
    // Hero match / Today
    GnMatch(
      id: 'm_1',
      tour: 'Journée 4',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'AS Kaloum',
      codeB: 'ASK',
      date: 'Aujourd\'hui',
      time: '16:30',
      score: null,
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'À venir',
      summary: 'Grand Classico de Conakry entre le leader et son rival historique.',
    ),
    GnMatch(
      id: 'm_2',
      tour: 'Journée 4',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'CI Kamsar',
      codeB: 'CIK',
      date: 'Aujourd\'hui',
      time: '18:45',
      score: null,
      stadium: 'Stade Petit Sory, Nongo',
      status: 'À venir',
      summary: 'Choc décisif pour la qualification en compétitions africaines.',
    ),
    GnMatch(
      id: 'm_3',
      tour: 'Journée 4',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'Ashanti Golden Boys',
      codeB: 'SAG',
      date: 'Demain',
      time: '16:00',
      score: null,
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'À venir',
      summary: 'Derby chaud de Haute-Guinée entre deux attaques prolifiques.',
    ),
    GnMatch(
      id: 'm_4',
      tour: 'Journée 4',
      teamA: 'Wakriya AC',
      codeA: 'WAC',
      teamB: 'Renaissance FC',
      codeB: 'RFC',
      date: 'Demain',
      time: '16:00',
      score: null,
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'À venir',
      summary: 'Opposition de style entre l\'impact physique et la possession.',
    ),
    GnMatch(
      id: 'm_5',
      tour: 'Journée 4',
      teamA: 'Satellite FC',
      codeA: 'SFC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: 'Demain',
      time: '18:15',
      score: null,
      stadium: 'Stade du 28 Septembre, Conakry',
      status: 'À venir',
      summary: 'Duel de milieu de tableau pour recoller au groupe de tête.',
    ),

    // Matchs récents (Terminés)
    GnMatch(
      id: 'm_6',
      tour: 'Journée 3',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'Hafia FC',
      codeB: 'HFC',
      date: 'Hier',
      time: '16:00',
      score: '2 - 1',
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'Terminé',
      summary: 'Horoya s\'impose au terme d\'un match haletant disputé jusqu\'au bout.',
    ),
    GnMatch(
      id: 'm_7',
      tour: 'Journée 3',
      teamA: 'AS Kaloum',
      codeA: 'ASK',
      teamB: 'Milo FC Kankan',
      codeB: 'MFC',
      date: 'Hier',
      time: '18:00',
      score: '1 - 1',
      stadium: 'Stade de la Mission, Kaloum',
      status: 'Terminé',
      summary: 'Partage des points après une égalisation rapide de Kankan.',
    ),
    GnMatch(
      id: 'm_8',
      tour: 'Journée 3',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: 'Hier',
      time: '16:00',
      score: '3 - 0',
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'Terminé',
      summary: 'Large succès de Kamsar avec un triplé retentissant de son avant-centre.',
    ),
    GnMatch(
      id: 'm_9',
      tour: 'Journée 3',
      teamA: 'Ashanti Golden Boys',
      codeA: 'SAG',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: '28 Oct',
      time: '16:00',
      score: '0 - 1',
      stadium: 'Stade de Siguiri, Siguiri',
      status: 'Terminé',
      summary: 'Victoire tactique à l\'extérieur de Satellite sur un contre éclair.',
    ),
    GnMatch(
      id: 'm_10',
      tour: 'Journée 3',
      teamA: 'Renaissance FC',
      codeA: 'RFC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: '28 Oct',
      time: '16:30',
      score: '2 - 2',
      stadium: 'Stade de la Mission, Kaloum',
      status: 'Terminé',
      summary: 'Festival offensif et match nul équitable pour les deux équipes.',
    ),

    // Journée 2
    GnMatch(
      id: 'm_11',
      tour: 'Journée 2',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'AS Kaloum',
      codeB: 'ASK',
      date: '24 Oct',
      time: '16:00',
      score: '2 - 0',
      stadium: 'Stade Petit Sory, Nongo',
      status: 'Terminé',
      summary: 'Hafia maîtrise son sujet et prend les 3 points avec autorité.',
    ),
    GnMatch(
      id: 'm_12',
      tour: 'Journée 2',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Horoya AC',
      codeB: 'HAC',
      date: '24 Oct',
      time: '16:00',
      score: '0 - 1',
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'Terminé',
      summary: 'Courte mais précieuse victoire à l\'extérieur pour Horoya.',
    ),
    GnMatch(
      id: 'm_13',
      tour: 'Journée 2',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: '23 Oct',
      time: '16:00',
      score: '2 - 1',
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'Terminé',
      summary: 'Milo FC arrache la victoire dans les arrêts de jeu grâce à son public.',
    ),
    GnMatch(
      id: 'm_14',
      tour: 'Journée 2',
      teamA: 'Flamme Olympique',
      codeA: 'FLA',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: '23 Oct',
      time: '16:30',
      score: '1 - 0',
      stadium: 'Stade de la Mission, Kaloum',
      status: 'Terminé',
      summary: 'Succès précieux pour Flamme qui ouvre son compteur de victoires.',
    ),
    GnMatch(
      id: 'm_15',
      tour: 'Journée 2',
      teamA: 'Ashanti Golden Boys',
      codeA: 'SAG',
      teamB: 'Renaissance FC',
      codeB: 'RFC',
      date: '22 Oct',
      time: '16:00',
      score: '3 - 1',
      stadium: 'Stade de Siguiri, Siguiri',
      status: 'Terminé',
      summary: 'Démonstration de force des miniers devant leurs supporters.',
    ),

    // Journée 1
    GnMatch(
      id: 'm_16',
      tour: 'Journée 1',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: '18 Oct',
      time: '16:00',
      score: '4 - 0',
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'Terminé',
      summary: 'Entrée en matière tonitruante du champion avec 4 réalisations.',
    ),
    GnMatch(
      id: 'm_17',
      tour: 'Journée 1',
      teamA: 'AS Kaloum',
      codeA: 'ASK',
      teamB: 'Renaissance FC',
      codeB: 'RFC',
      date: '18 Oct',
      time: '18:00',
      score: '2 - 1',
      stadium: 'Stade de la Mission, Kaloum',
      status: 'Terminé',
      summary: 'Kaloum démarre sa campagne par une victoire appliquée.',
    ),
    GnMatch(
      id: 'm_18',
      tour: 'Journée 1',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'Ashanti Golden Boys',
      codeB: 'SAG',
      date: '17 Oct',
      time: '16:00',
      score: '1 - 1',
      stadium: 'Stade Petit Sory, Nongo',
      status: 'Terminé',
      summary: 'Match équilibré qui se solde par un partage équitable des points.',
    ),
    GnMatch(
      id: 'm_19',
      tour: 'Journée 1',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Milo FC Kankan',
      codeB: 'MFC',
      date: '17 Oct',
      time: '16:00',
      score: '0 - 0',
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'Terminé',
      summary: 'Les deux gardiens se sont illustrés par de multiples parades.',
    ),
    GnMatch(
      id: 'm_20',
      tour: 'Journée 1',
      teamA: 'Wakriya AC',
      codeA: 'WAC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: '16 Oct',
      time: '16:00',
      score: '1 - 2',
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'Terminé',
      summary: 'Surprise avec la victoire à l\'arraché de Flamme Olympique.',
    ),

    // Matchs futurs (Journée 5)
    GnMatch(
      id: 'm_21',
      tour: 'Journée 5',
      teamA: 'Renaissance FC',
      codeA: 'RFC',
      teamB: 'Horoya AC',
      codeB: 'HAC',
      date: '08 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade de la Mission, Kaloum',
      status: 'À venir',
      summary: 'Déplacement de Horoya pour conforter sa place de leader.',
    ),
    GnMatch(
      id: 'm_22',
      tour: 'Journée 5',
      teamA: 'Flamme Olympique',
      codeA: 'FLA',
      teamB: 'Hafia FC',
      codeB: 'HFC',
      date: '08 Nov',
      time: '18:00',
      score: null,
      stadium: 'Stade Petit Sory, Nongo',
      status: 'À venir',
      summary: 'Flamme reçoit un des prétendants au titre national.',
    ),
    GnMatch(
      id: 'm_23',
      tour: 'Journée 5',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: '09 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'À venir',
      summary: 'Opposition attendue entre deux formations en quête de constance.',
    ),
    GnMatch(
      id: 'm_24',
      tour: 'Journée 5',
      teamA: 'AS Kaloum',
      codeA: 'ASK',
      teamB: 'Ashanti Golden Boys',
      codeB: 'SAG',
      date: '09 Nov',
      time: '16:30',
      score: null,
      stadium: 'Stade de la Mission, Kaloum',
      status: 'À venir',
      summary: 'Les kaloumkas face à la formation expérimentée de Siguiri.',
    ),
  ];

  GnMatch? getNearestMatch() {
    final upcoming = matches.where((m) => m.date == 'Aujourd\'hui' && !m.isFinished).toList();
    if (upcoming.isNotEmpty) return upcoming.first;
    final anyUpcoming = matches.where((m) => !m.isFinished).toList();
    if (anyUpcoming.isNotEmpty) return anyUpcoming.first;
    return matches.isNotEmpty ? matches.first : null;
  }

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fav = prefs.getStringList('fav_matches_goyellow');
      if (fav != null) {
        _favMatchIds.clear();
        _favMatchIds.addAll(fav);
      }
      final name = prefs.getString('user_name_goyellow');
      if (name != null) _userName = name;
      final team = prefs.getString('fav_team_goyellow');
      if (team != null) _favoriteTeam = team;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('fav_matches_goyellow', _favMatchIds.toList());
      await prefs.setString('user_name_goyellow', _userName);
      await prefs.setString('fav_team_goyellow', _favoriteTeam);
    } catch (_) {}
  }

  void toggleFavorite(String id) {
    if (_favMatchIds.contains(id)) {
      _favMatchIds.remove(id);
    } else {
      _favMatchIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void updateProfile(String name, String team) {
    _userName = name;
    _favoriteTeam = team;
    _save();
    notifyListeners();
  }

  void resetData() {
    _favMatchIds.clear();
    _userName = 'Supporter Guinée';
    _favoriteTeam = 'Horoya AC';
    _save();
    notifyListeners();
  }
}
