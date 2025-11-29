import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HighScoreEntry {
  final String playerName;
  final int score;
  final DateTime date;

  HighScoreEntry({
    required this.playerName,
    required this.score,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'score': score,
        'date': date.toIso8601String(),
      };

  factory HighScoreEntry.fromJson(Map<String, dynamic> json) => HighScoreEntry(
        playerName: json['playerName'],
        score: json['score'],
        date: DateTime.parse(json['date']),
      );
}

class HighScoreManager {
  static const String _key = 'high_scores';
  static const int maxScores = 10;

  static Future<List<HighScoreEntry>> getHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresJson = prefs.getString(_key);
    
    if (scoresJson == null) return [];
    
    final List<dynamic> scoresList = jsonDecode(scoresJson);
    return scoresList
        .map((json) => HighScoreEntry.fromJson(json))
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  static Future<void> addScore(String playerName, int score) async {
    final scores = await getHighScores();
    
    scores.add(HighScoreEntry(
      playerName: playerName,
      score: score,
      date: DateTime.now(),
    ));
    
    // Sort by score descending
    scores.sort((a, b) => b.score.compareTo(a.score));
    
    // Keep only top scores
    final topScores = scores.take(maxScores).toList();
    
    // Save to storage
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = jsonEncode(
      topScores.map((entry) => entry.toJson()).toList(),
    );
    await prefs.setString(_key, scoresJson);
  }

  static Future<bool> isHighScore(int score) async {
    final scores = await getHighScores();
    if (scores.length < maxScores) return true;
    return score > scores.last.score;
  }

  static Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> savePlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_name', name);
  }

  static Future<String> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('player_name') ?? 'Player';
  }
}
