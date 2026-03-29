import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import '../view_model/artist_detail_view_model.dart';
import 'comment_tile.dart';

class ArtistDetailContent extends StatefulWidget {
  const ArtistDetailContent({super.key});

  @override
  State<ArtistDetailContent> createState() => _ArtistDetailContentState();
}

class _ArtistDetailContentState extends State<ArtistDetailContent> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mv = context.watch<ArtistDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(mv.artist.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1 - Artist Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(mv.artist.imageUrl.toString()),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mv.artist.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(mv.artist.genre, style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            Divider(),

            // 2 - Songs list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Songs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            switch (mv.songsValue.state) {
              AsyncValueState.loading => Center(child: CircularProgressIndicator()),
              AsyncValueState.error => Text('Error: ${mv.songsValue.error}', style: TextStyle(color: Colors.red)),
              AsyncValueState.success => Column(
                children: mv.songsValue.data!.map((Song song) {
                  final isSelected = mv.selectedSong?.id == song.id;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(song.imageUrl.toString()),
                    ),
                    title: Text(song.title),
                    subtitle: Text('${song.duration.inMinutes} mins'),
                    selected: isSelected,
                    selectedTileColor: Colors.blue.withOpacity(0.1),
                    onTap: () => mv.selectSong(song),
                  );
                }).toList(),
              ),
            },

            Divider(),

            // 3 - Comments section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Comments for: ${mv.selectedSong?.title ?? ""}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            switch (mv.commentsValue.state) {
              AsyncValueState.loading => Center(child: CircularProgressIndicator()),
              AsyncValueState.error => Center(child: Text('Error: ${mv.commentsValue.error}', style: TextStyle(color: Colors.red))),
              AsyncValueState.success => mv.commentsValue.data!.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('No comments yet. Be the first!', style: TextStyle(color: Colors.grey)),
                  )
                : Column(
                    children: mv.commentsValue.data!
                        .map((c) => CommentTile(comment: c))
                        .toList(),
                  ),
            },

            Divider(),

            // 4 - Post comment form
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add a comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Comment',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 8),
                  if (mv.postCommentValue.state == AsyncValueState.error)
                    Text('Failed to post comment', style: TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: mv.postCommentValue.state == AsyncValueState.loading
                        ? null
                        : () async {
                            final username = _usernameController.text.trim();
                            final comment = _commentController.text.trim();
                            if (username.isEmpty || comment.isEmpty) return;
                            await mv.postComment(username, comment);
                            _usernameController.clear();
                            _commentController.clear();
                          },
                    child: mv.postCommentValue.state == AsyncValueState.loading
                        ? CircularProgressIndicator()
                        : Text('Post Comment'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
