import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../services/api_service.dart';

class CharacterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Character> _characters = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;
  int _totalCount = 0;

  // Getters
  List<Character> get characters => _characters;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _hasPreviousPage;
  int get totalCount => _totalCount;
  int get totalPages => (_totalCount / 10).ceil();

  Future<void> fetchCharacters({int page = 1}) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.fetchCharacters(page);
      _characters = response.results;
      _hasNextPage = response.hasNextPage;
      _hasPreviousPage = response.hasPreviousPage;
      _currentPage = page;
      _totalCount = response.count;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_hasNextPage) fetchCharacters(page: _currentPage + 1);
  }

  void previousPage() {
    if (_hasPreviousPage) fetchCharacters(page: _currentPage - 1);
  }
}