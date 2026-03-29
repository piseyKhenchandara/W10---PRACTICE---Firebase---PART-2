import '../../model/comment/comment.dart';

class CommentDto {
  static const String usernameKey = 'username';
  static const String commentKey = 'comment';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    return Comment(
      id: id,
      username: json[usernameKey],
      comment: json[commentKey],
    );
  }

  static Map<String, dynamic> toJson(String username, String comment) {
    return {
      usernameKey: username,
      commentKey: comment,
    };
  }
}
