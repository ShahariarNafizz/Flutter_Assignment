class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  // ইন্টারনেট (JSON) থেকে আসা ডেটাকে আমাদের অ্যাপের ব্যবহারযোগ্য (Dart Object) বানানোর জন্য
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  // ডেটা লোকাল স্টোরেজে সেভ করার সময় কাজে লাগবে
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
