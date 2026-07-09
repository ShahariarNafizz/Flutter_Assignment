import 'package:flutter/material.dart';
import '../models/post_model.dart';

class DetailScreen extends StatelessWidget {
  final Post post;

  DetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.article_rounded,
                        color: Colors.blueAccent, size: 28),
                    SizedBox(width: 10),
                    Text(
                      'Post ID: ${post.id}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ],
                ),
                Divider(height: 30, thickness: 1, color: Colors.grey.shade200),
                Text(
                  post.title.toUpperCase(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      height: 1.4),
                ),
                SizedBox(height: 20),
                Text(
                  post.body,
                  style: TextStyle(
                      fontSize: 16, height: 1.8, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
