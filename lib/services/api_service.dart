import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Read with Pagination: পেজ এবং লিমিট অনুযায়ী ডেটা আনা
  Future<List<Post>> fetchPosts({int page = 1, int limit = 10}) async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl?_page=$page&_limit=$limit'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts from API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create
  Future<Post> createPost(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({'title': title, 'body': body, 'userId': 1}),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update
  Future<Post> updatePost(int id, String title, String body) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        body:
            json.encode({'id': id, 'title': title, 'body': body, 'userId': 1}),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete
  Future<bool> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
