import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../models/post_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchAndCachePosts();
    });
  }

  void _showPostDialog(BuildContext context, {Post? post}) {
    final _titleController = TextEditingController(text: post?.title ?? '');
    final _bodyController = TextEditingController(text: post?.body ?? '');
    final provider = Provider.of<PostProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(post == null ? 'Add New Post' : 'Edit Post',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                    labelText: 'Body',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _bodyController.text.isNotEmpty) {
                  if (post == null) {
                    provider.addPost(
                        _titleController.text, _bodyController.text);
                  } else {
                    provider.updatePost(
                        post.id, _titleController.text, _bodyController.text);
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(post == null ? 'Post Added!' : 'Post Updated!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text('Save',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:
            Text('API Explorer', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // Dark Mode Toggle Button
          IconButton(
            icon: Icon(
                provider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              provider.toggleTheme();
            },
          ),
          // Sorting Popup Menu
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              provider.setSortType(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'ID (Ascending)',
                  child: Text('Sort by ID (Ascending)')),
              PopupMenuItem(
                  value: 'ID (Descending)',
                  child: Text('Sort by ID (Descending)')),
              PopupMenuItem(
                  value: 'A to Z', child: Text('Sort A to Z (Title)')),
              PopupMenuItem(
                  value: 'Z to A', child: Text('Sort Z to A (Title)')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () => _showPostDialog(context),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : RefreshIndicator(
              color: Colors.blueAccent,
              onRefresh: () async {
                _searchController.clear();
                provider.setSearchQuery('');
                await provider.fetchAndCachePosts();
              },
              child: Column(
                children: [
                  if (provider.errorMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: Colors.redAccent,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              provider.errorMessage,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Modern 3D Search Bar (Dark Mode Compatible)
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        provider.setSearchQuery(value);
                      },
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search posts...',
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 8.0),
                          child: Icon(Icons.search_rounded,
                              color: Colors.blueAccent, size: 26),
                        ),
                        suffixIcon: provider.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.cancel_rounded,
                                    color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  provider.setSearchQuery('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),
                  ),

                  Expanded(
                    child: provider.posts.isEmpty
                        ? Center(
                            child: Text('No Data Found!',
                                style: TextStyle(fontSize: 16)))
                        : ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            itemCount: provider.posts.length + 1,
                            itemBuilder: (context, index) {
                              if (index == provider.posts.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 40),
                                  child: provider.isFetchingMore
                                      ? Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.blueAccent))
                                      : ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                          ),
                                          icon: Icon(Icons.expand_more,
                                              color: Colors.white),
                                          label: Text('Load More',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          onPressed: () {
                                            provider.fetchMorePosts();
                                          },
                                        ),
                                );
                              }

                              final post = provider.posts[index];
                              final isFavorite =
                                  provider.favoriteIds.contains(post.id);

                              return Card(
                                elevation: isDark ? 1 : 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(12),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        Colors.blueAccent.withOpacity(0.1),
                                    child: Text(
                                      post.id.toString(),
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  title: Text(
                                    post.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      post.body,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(height: 1.3),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Favorite Button
                                      IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          provider.toggleFavorite(post.id);
                                        },
                                      ),
                                      // Edit Button
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.orangeAccent),
                                        onPressed: () => _showPostDialog(
                                            context,
                                            post: post),
                                      ),
                                      // Delete Button
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          provider.deletePost(post.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailScreen(post: post),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
