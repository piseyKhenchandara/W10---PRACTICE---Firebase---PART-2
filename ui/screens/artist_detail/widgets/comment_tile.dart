import 'package:flutter/material.dart';
import '../../../../model/comment/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(comment.username[0].toUpperCase()),
          ),
          title: Text(comment.username, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(comment.comment),
        ),
      ),
    );
  }
}
