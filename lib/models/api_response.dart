import 'character.dart';

class ApiResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Character> results;

  const ApiResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get hasNextPage => next != null;
  bool get hasPreviousPage => previous != null;
}