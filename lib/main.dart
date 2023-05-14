import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

void main() => runApp(NailApp());

class NailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Just Nail it!!!',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              fontFamily: 'Courgette',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.5), BlendMode.dstATop),
                image: new AssetImage(
                  'assets/images/bg_image.png',
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: HomePage(),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Color>> _getColorsFromImage(File imageFile) async {
    final paletteGenerator =
        await PaletteGenerator.fromImageProvider(FileImage(imageFile));
    final colors = paletteGenerator.colors.toList();
    final matchingColors = nailColors.where((color) {
      return colors.any((c) =>
          c.computeLuminance() > 0.2 &&
          c.computeLuminance() < 0.8 &&
          Color.alphaBlend(c, color['color'] as Color) == c);
    }).toList();
    return colors;
  }

  final nailColors = [
    {
      'name': 'Red',
      'color': Colors.red,
    },
    {
      'name': 'Pinkish Purple',
      'color': Colors.purpleAccent,
    },
    {
      'name': 'Navy Blue',
      'color': Colors.blue[900]!,
    },
    {
      'name': 'Dark Purple',
      'color': Colors.purple[800]!,
    },
  ];

  ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final colors = await _getColorsFromImage(File(image.path));
      // TODO: suggest nail colors based on the extracted colors
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(File(_image!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null
                      ? Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select a photo to get nail color suggestions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Popular color scheme==>',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 30),
                  CircleAvatar(
                    radius: 62,
                    backgroundImage: AssetImage('assets/images/palette1.jpeg'),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
/*  @override
  Widget build(BuildContext context) {
    Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        image: _image == null
            ? null
            : DecorationImage(
                image: FileImage(File(_image!.path)),
                fit: BoxFit.cover,
              ),
      ),
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: ElevatedButton(
            child: Text(
              'Select Skin tone',
              style: TextStyle(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                color: Colors.black45,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightGreen,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              _getImage();
            },
          ),
        ),
        if (_image != null)
          Image.file(
            File(_image!.path),
            width: 25,
            height: 25,
          ),
        Padding(
          padding: EdgeInsets.all(10),
          child: FloatingActionButton.large(
            child: Text(
              'Suggest',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal,
                color: Colors.blueGrey[20],
              ),
            ),
            backgroundColor: Colors.red,
            onPressed: () {
              setState(
                () {},
              );
            },
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 55,
                child: Text(
                  'The following is a matching color scheme for your nail polish==>',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
              // SizedBox(width: 10),
              Container(
                child: CircleAvatar(
                  radius: 85,
                  backgroundImage: AssetImage('assets/images/palette1.jpeg'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          height: 35,
          child: Text(
            'These colors might be of your liking:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image.asset(
                'assets/images/redw.png',
                height: 80,
                width: 80,
              ),
            ),
            Container(
              child: Image.asset('assets/images/lightPurplew.png',
                  height: 80, width: 80),
            ),
            Container(
              child: Image.asset('assets/images/navyBluew.jpeg',
                  height: 80, width: 80),
            ),
            Container(
              child: Image.asset('assets/images/darkPurplew.jpeg',
                  height: 80, width: 80),
            )
          ],
        )),
        SizedBox(height: 15),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Red'),
              Text('Pinkish Purple'),
              Text('Navy Blue'),
              Text('Dark Purple')
            ],
          ),
        )
      ],
    );
  }
}
*/
