import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
<<<<<<< HEAD
import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:path/path.dart" show dirname;
=======
import 'package:http/http.dart' as http;
import "package:path/path.dart" show dirname;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:scoped_model/scoped_model.dart';
>>>>>>> 5bfc57b977959524083ea62e37a500b320154b20

import 'package:ipm_p2/model.dart';

//void main() => runApp(new MyHomePage());
void main() {
  runApp(MyApp(
    model: ImageModel(),
  ));
}

class MyApp extends StatelessWidget {
  final ImageModel model;

  const MyApp({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // At the top level of our app, we'll, create a ScopedModel Widget. This
    // will provide the CounterModel to all children in the app that request it
    // using a ScopedModelDescendant.
    return ScopedModel<ImageModel>(
      model: model,
      child: MaterialApp(
        title: 'Scoped Model Demo',
        home: View(), ////////////////////////
      ),
    );
  }
}

class View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
<<<<<<< HEAD
        title: new Text('IPM-P2'),
      ),
      body: new Center(
        child: _image == null
            ? new Text('No image selected.')
        //: new Image.file(_image),
            : new Image.file(convertImage()),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.camera_alt),
      ),
    );
  }

  convertImage() async {
    var image = File(_image.path);
    var imageAsBytes = await image.readAsBytes();

// Creating request
// NOTE: In the emulator, localhost ip is 10.0.2.2
    var uri = Uri.parse('http://127.0.0.1:5000/cartoon');
    var request = http.MultipartRequest("POST", uri);
    var inputFile = http.MultipartFile.fromBytes(
        'image', imageAsBytes, filename: 'image.jpg');
    request.files.add(inputFile);

      // Sending request and waiting for response
      var response = await request.send();
      if (response.statusCode == 200) {
      // Receiving response stream
      var responseStr = await response.stream.bytesToString();

      // Converting response string to json dictionary
      var data = jsonDecode(responseStr);

      // Accessing response data
      var cartoon = data['cartoon'];
      if (cartoon != null) {
      // Creating the output file
        var outputFile = File("/home/franjm1116/Escritorio/ipm-p2/cartoon.png");
      // Decoding base64 string received as response
        var imageResponse = base64.decode(cartoon);
        // Writing the decoded image to the output file
        await outputFile.writeAsBytes(imageResponse);
        return outputFile;
      }
    }
  }

/***
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    class convert_image extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
    var image = ;/////////////////////////////////////////////////////////////////////////////////////////
    var imageAsBytes = await image.readAsBytes();/////////////////////////////////////////////////////////////////////////

    // Creating request
    // NOTE: In the emulator, localhost ip is 10.0.2.2
    var uri = Uri.parse('http://127.0.0.1:5000/cartoon');///////////////////////////////////////////////////////////////////
    var request = http.MultipartRequest("POST", uri);////////////////////////////////////////////////////////////////////////////
    var inputFile = http.MultipartFile.fromBytes('image', imageAsBytes, filename: 'image.jpg');///////////////////////////////////////
    request.files.add(inputFile);//////////////////////////////////////////////////////////////////////////////////////////////////

    try {///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Sending request and waiting for response
    var response = await request.send();/////////////////////////////////////////////////////////////////////////////////////////////
    if (response.statusCode == 200) {////////////////////////////////////////////////////////////////////////////////////////////
    // Receiving response stream
    var responseStr = await response.stream.bytesToString();/////////////////////////////////////////////////////////////////

    // Converting response string to json dictionary
    var data = jsonDecode(responseStr);///////////////////////////////////////////////////////////////////////////////////////

    // Accessing response data
    var cartoon = data['cartoon'];///////////////////////////////////////////////////////////////////////////////////////
    if (cartoon != null) {///////////////////////////////////////////////////////////////////////////////////////////////
    // Creating the output file

    // Decoding base64 string received as response
    var imageResponse = base64.decode(cartoon);/////////////////////////////////////////////////////////////////
    return imageResponse
    // Writing the decoded image to the output file
    //await outputFile.writeAsBytes(imageResponse);////////////////////////////////////////////////////////////////

    //print( 'Server is down');////////////////////////////////////////////////////////////////////////////////////////////////////


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }

    }*/

=======
        title: new Text('Cartoongram'),
      ),
      body: ScopedModelDescendant<ImageModel>(
        builder: (context, child, model) {
          ////
          return Center(
            child: model.cartoon == null
                ? new Text('No se ha realizado ninguna fotografía')
                : new Image.file(model.cartoon),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ScopedModelDescendant<ImageModel>(
            builder: (context, child, model) {
              return FloatingActionButton(
                onPressed: model.getImage,
                tooltip: 'Pick Image',
                child: new Icon(Icons.camera_alt),
              );
            },
          ),
          ScopedModelDescendant<ImageModel>(
            builder: (context, child, model) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  onPressed: model.shareImage,
                  tooltip: 'ShareImage',
                  child: new Icon(Icons.share),
                ),
              );
            },
          ),
          ScopedModelDescendant<ImageModel>(
            builder: (context, child, model) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  //onPressed:_onImageButtonPressed(ImageSource.gallery);,
                  tooltip: 'Gallery',
                  child: new Icon(Icons.photo_library),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
>>>>>>> 5bfc57b977959524083ea62e37a500b320154b20
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
