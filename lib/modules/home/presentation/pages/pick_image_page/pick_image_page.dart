import 'dart:io';
import 'package:flutter/material.dart';
import 'package:marshal_test_app/modules/home/presentation/controllers/home_controllers.dart';
import 'package:provider/provider.dart';

class PickImagePage extends StatelessWidget {
  const PickImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, home, child) {
        final imagePath = home.state.selectedImagePath;

        return Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null) ...[
                Image.file(
                  File(imagePath),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => home.pickImageFromGallery(context),
                      icon: const Icon(Icons.update),
                      label: const Text("Update"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: home.clearImage,
                      icon: const Icon(Icons.delete),
                      label: const Text("Clear"),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: () => home.pickImageFromGallery(context),
                  icon: const Icon(Icons.image),
                  label: const Text("Pick Image"),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
