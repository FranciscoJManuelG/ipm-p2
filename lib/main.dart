import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

import 'dart:convert';
import 'package:http/http.dart' as http;
//import "package:path/path.dart" show dirname;


//void main() => runApp(new MyHomePage());
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'IPM-P2',
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  File _image;

  Future getImage() async {
    //represent the results of asynchronous operations
    var image = await ImagePicker.pickImage(source: ImageSource
        .camera); //To suspend execution until a future completes

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Image Picker Example'),
      ),
      body: new Center(
        child: _image == null
            ? new Text('No image selected.')
        //: new Image.file(_image),
            : new Image.file(convert_image()),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  convert_image() async {
    var image = File(_image.path);
    var imageAsBytes = await image.readAsBytes();

// Creating request
// NOTE: In the emulator, localhost ip is 10.0.2.2
    var uri = Uri.parse('http://127.0.0.1:5000/cartoon');
    var request = http.MultipartRequest("POST", uri);
    var inputFile = http.MultipartFile.fromBytes(
        'image', imageAsBytes, filename: 'image.jpg');
    request.files.add(inputFile);

    //try {///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

// Decoding base64 string received as response
        var imageResponse = base64.decode(
            cartoon);
        return imageResponse;
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

}
