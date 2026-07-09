import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  String _errorMessage = '';
  int _currentPage = 1;
  String _searchQuery = '';

  // নতুন ভ্যারিয়েবলস
  bool _isDarkMode = false;
  List<int> _favoriteIds = [];
  String _sortType = 'ID (Ascending)'; // ডিফল্ট সর্টিং

  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isDarkMode => _isDarkMode;
  List<int> get favoriteIds => _favoriteIds;
  String get sortType => _sortType;

  final ApiService _apiService = ApiService();
  final String _boxName = 'postsBox';

  PostProvider() {
    _loadSettings(); // অ্যাপ চালু হলে থিম ও ফেভারিট লোড করবে
  }

  void _loadSettings() {
    var box = Hive.box(_boxName);
    _isDarkMode = box.get('isDarkMode', defaultValue: false);
    _favoriteIds = List<int>.from(box.get('favoriteIds', defaultValue: []));
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    Hive.box(_boxName).put('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    Hive.box(_boxName).put('favoriteIds', _favoriteIds);
    notifyListeners();
  }

  void setSortType(String type) {
    _sortType = type;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ডেটা পাঠানো, ফিল্টার করা এবং সর্ট করার মেথড
  List<Post> get posts {
    List<Post> filteredList = _posts;

    // ১. Search Filtering
    if (_searchQuery.isNotEmpty) {
      filteredList = _posts
          .where((post) =>
              post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              post.body.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // ২. Sorting
    if (_sortType == 'A to Z') {
      filteredList.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortType == 'Z to A') {
      filteredList.sort((a, b) => b.title.compareTo(a.title));
    } else if (_sortType == 'ID (Descending)') {
      filteredList.sort((a, b) => b.id.compareTo(a.id));
    } else {
      filteredList.sort((a, b) => a.id.compareTo(b.id)); // ID (Ascending)
    }

    return filteredList;
  }

  void _updateCache() {
    var box = Hive.box(_boxName);
    List<Map<String, dynamic>> cacheData =
        _posts.map((p) => p.toJson()).toList();
    box.put('cachedPosts', cacheData);
  }

  Future<void> fetchAndCachePosts() async {
    _isLoading = true;
    _errorMessage = '';
    _currentPage = 1;
    notifyListeners();

    try {
      _posts = await _apiService.fetchPosts(page: _currentPage, limit: 10);
      _updateCache();
    } catch (e) {
      var box = Hive.box(_boxName);
      if (box.containsKey('cachedPosts')) {
        List<dynamic> cachedData = box.get('cachedPosts');
        _posts = cachedData
            .map((data) => Post.fromJson(Map<String, dynamic>.from(data)))
            .toList();
        _errorMessage = 'Offline Mode: Showing cached data.';
      } else {
        _errorMessage = 'No internet connection and no cached data!';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    if (_isFetchingMore) return;
    _isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      List<Post> morePosts =
          await _apiService.fetchPosts(page: _currentPage, limit: 10);
      if (morePosts.isNotEmpty) {
        _posts.addAll(morePosts);
        _updateCache();
      }
    } catch (e) {
      _currentPage--;
      _errorMessage = 'Failed to load more data!';
    }

    _isFetchingMore = false;
    notifyListeners();
  }

  // CRUD Operations...
  Future<void> addPost(String title, String body) async {
    try {
      Post newPost = await _apiService.createPost(title, body);
      _posts.insert(0, newPost);
      _updateCache();
      notifyListeners();
    } catch (e) {
      Post localPost = Post(
          id: DateTime.now().millisecondsSinceEpoch % 100000,
          title: title,
          body: body);
      _posts.insert(0, localPost);
      _updateCache();
      notifyListeners();
    }
  }

  Future<void> updatePost(int id, String title, String body) async {
    try {
      Post updatedPost = await _apiService.updatePost(id, title, body);
      int index = _posts.indexWhere((post) => post.id == id);
      if (index != -1) {
        _posts[index] = updatedPost;
        _updateCache();
        notifyListeners();
      }
    } catch (e) {
      int index = _posts.indexWhere((post) => post.id == id);
      if (index != -1) {
        _posts[index] = Post(id: id, title: title, body: body);
        _updateCache();
        notifyListeners();
      }
    }
  }

  Future<void> deletePost(int id) async {
    try {
      await _apiService.deletePost(id);
      _posts.removeWhere((post) => post.id == id);
      _updateCache();
      notifyListeners();
    } catch (e) {
      _posts.removeWhere((post) => post.id == id);
      _updateCache();
      notifyListeners();
    }
  }
}
