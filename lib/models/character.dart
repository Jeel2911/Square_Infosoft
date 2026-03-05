import 'package:intl/intl.dart';

class Character {
  final String name;
  final String height;
  final String mass;
  final String birthYear;
  final String created;
  final List<String> films;

  const Character({
    required this.name,
    required this.height,
    required this.mass,
    required this.birthYear,
    required this.created,
    required this.films,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? 'Unknown',
      height: json['height'] ?? 'unknown',
      mass: json['mass'] ?? 'unknown',
      birthYear: json['birth_year'] ?? 'unknown',
      created: json['created'] ?? '',
      films: List<String>.from(json['films'] ?? []),
    );
  }

  // Height: convert cm → meters
  String get heightInMeters {
    final h = double.tryParse(height);
    if (h == null) return 'Unknown';
    return '${(h / 100).toStringAsFixed(2)} m';
  }

  // Mass in kg
  String get massInKg {
    return mass == 'unknown' ? 'Unknown' : '$mass kg';
  }

  // Date in dd-MM-yyyy format
  String get formattedDate {
    try {
      final date = DateTime.parse(created);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (_) {
      return 'Unknown';
    }
  }

  // Number of films
  int get filmCount => films.length;
}