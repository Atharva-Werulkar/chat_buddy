import 'package:chat_buddy/main.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ShowPicture extends StatelessWidget {
  final String imageUrl;

  const ShowPicture({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Picture'),
      ),
      body: InteractiveViewer(
        alignment: Alignment.center,
        minScale: 0.5, // Set the minimum scale value
        maxScale: 4.0, // Set the maximum scale value
        child: Center(
          child: SizedBox(
            height: size.height * .50,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
