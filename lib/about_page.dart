import 'package:flutter/material.dart';
import 'package:habbie/theme.dart';

class AboutHabbie extends StatelessWidget {
  const AboutHabbie({super.key});

  @override
  Widget build(BuildContext context) {
      List<ImageData> teamInfo = [
        const ImageData(
            name: "Mr. Anouluck Many",
            description: "The good for nothing",
            imgName: "anouluck"
        ),
        const ImageData(
            name: "Mr. Bounphaeng Khamvongphet",
            description: "The class president",
            imgName: "bounphang"
        ),
        const ImageData(
            name: "Mr. Inkham Xaiyajak",
            description: "The badass",
            imgName: "inkham"
        ),
        const ImageData(
            name: "Mr. Phasouk Nammavong",
            description: "The lover",
            imgName: "phasouk"
        ),
        const ImageData(
            name: "Mr. Phetsakhone Xaiphavongsa",
            description: "The chill",
            imgName: "phetsakhone"
        ),
        const ImageData(
            name: "Mr. Houachang Tongya",
            description: "The mysterious",
            imgName: "houachang"
        ),
      ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HabbieTheme.primary,
          foregroundColor: HabbieTheme.onPrimary,
          title: const Text("About"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "Habbie is a minimalist application for tracking habits designed for less distraction and intuitive interface. Perfect for those who value simplicity and effectiveness in their personal growth journey.",
                    style: TextStyle(fontSize: 18),
                  )),
              const SizedBox(height: 20),
              const Text("Special thanks to:", style: TextStyle(fontSize: 24)),
              const AboutPageImageWidget(
                  imageData: ImageData(
                      name: "Dr. Savat Saypadith",
                      description: 'Our professor',
                      imgName: 'prof')),
              const Text("Our team:", style: TextStyle(fontSize: 24)),
              for (var item in teamInfo) AboutPageImageWidget(imageData: item),
            ],
          ),
        ));
  }
}

class ImageData {
  final String name;
  final String description;
  final String imgName;

  const ImageData(
      {required this.name, required this.description, required this.imgName});
}

class AboutPageImageWidget extends StatelessWidget {
  final ImageData imageData;

  const AboutPageImageWidget({
    super.key,
    required this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 200,
              height: 200,
              child: CircleAvatar(
              radius: 100,
                backgroundImage: AssetImage('assets/images/${imageData.imgName}.jpg'),
              ),
            ),
          ),
          Text(imageData.name, style: const TextStyle(fontSize: 18)),
          Text(imageData.description,
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
