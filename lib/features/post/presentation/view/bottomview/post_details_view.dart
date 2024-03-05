import 'package:bigtalk/features/post/domain/entity/post_entity.dart';
import 'package:bigtalk/features/post/presentation/view_model/post_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final PostEntity post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call the getCommentByPostID method after the first frame is rendered
      ref
          .read(postViewModelProvider.notifier)
          .getCommentByPostID(widget.post.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.post.owner?.name ?? 'Unknown User'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.caption ?? 'No caption',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                if (widget.post.image != null && widget.post.image!.isNotEmpty)
                  Column(
                    children: widget.post.image!.map((image) {
                      return Image.network(image);
                    }).toList(),
                  ),
                const SizedBox(height: 16),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Replies:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                if (widget.post.comments != null &&
                    widget.post.comments!.isNotEmpty)
                  Column(
                    children: widget.post.comments!.map((comment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.comment ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'By: ${comment.owner?.name ?? 'Unknown'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                if (widget.post.comments == null ||
                    widget.post.comments!.isEmpty)
                  const Text(
                    'No replies yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
