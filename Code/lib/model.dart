import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import "package:path/path.dart" show dirname;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:scoped_model/scoped_model.dart';


class ImageModel extends Model {
  File _image;
  File _cartoon;
  var _temp;
  var i = 0;
  Future<File> _imageFile;

  File get cartoon => _cartoon;

  Future getImage() async {
    //represent the results of asynchronous operations
    var image = await ImagePicker.pickImage(source: ImageSource
        .camera); //To suspend execution until a future completes

      _image = image;
      notifyListeners();
    var cartoon = await convertImage();

      _cartoon = cartoon;
      print(_cartoon);
    notifyListeners();
  }

  convertImage() async{

    // Getting the absolute path to this script file
    //var currentPath = dirname(Platform.script.path);
    // Generating  absolute paths for the input/output images
    var pathImage=_image.path;
    Directory appDocDir;
    appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    i = i+1;
    var pathCartoon= appDocPath+"/cartoon"+i.toString()+".png";
    // Reading image
    var image = File(pathImage);
    var imageAsBytes = await image.readAsBytes();

    // Creating request
    // NOTE: In the emulator, localhost ip is 10.0.2.2
    var uri = Uri.parse('http://10.0.2.2:5000/cartoon');//en el emulador
    //var uri = Uri.parse('http://192.168.1.35:5000/cartoon');//en el movil
    var request = http.MultipartRequest("POST", uri);
    var inputFile = http.MultipartFile.fromBytes('image', imageAsBytes, filename: 'image.jpg');
    request.files.add(inputFile);

    try {
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
          var outputFile = File(pathCartoon);
          // Decoding base64 string received as response
          var imageResponse = base64.decode(cartoon);

          // Writing the decoded image to the output file
          var f = await outputFile.writeAsBytes(imageResponse);

          _temp=cartoon.toString();

          return f;
        }
      }
    } catch  (e) {
      print( 'Server is down');
    }
  }
  Future shareImage() async {
    String BASE64_IMAGE ="data:image/png;base64, "+_temp;
    //String BASE64_IMAGE =base64aa.patch;
    AdvancedShare.generic(
        msg: "Base64 file share",
        subject: "Flutter",
        title: "Share Image",
        type: "image/png",
        url: BASE64_IMAGE
    ).then( (response) {
      print(response);
    }
    );
  }


}



