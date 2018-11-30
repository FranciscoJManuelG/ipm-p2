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

  String patchImages;
  String patchCount;
  File _image;
  File _cartoon;
  var _temp;
  Future<File> _imageFile;


  File get cartoon => _cartoon;

  static Future<String> get localPathname async {//para acceder desde fuera al pathImages
    var directory = await getApplicationDocumentsDirectory();

    return directory.path+"/cartoon";
  }

  static Future<int> get count async {//para acceder desde fuera al numero almacenado en /count

    var directory = await getApplicationDocumentsDirectory();
    String patch = directory.path+"counter.txt";

    var counterfile = File(patch);

    String a=counterfile.readAsStringSync();

     return int.parse(a);
  }

   Future<int> get verifyCount async {//para verificar si tenemos algun numero en /count

    var directory = await getApplicationDocumentsDirectory();
    String patch = directory.path+"counter.txt";

    var counterfile = File(patch);

    String a=counterfile.readAsStringSync();
     return int.parse(a);
  }

  Future<String> get patchCountInit async {//para establecer variable patchCount en constructor

    var directory = await getApplicationDocumentsDirectory();
    patchCount = directory.path+"counter.txt";
    try {
      String a = File(patchCount).readAsStringSync();
    }catch (e){
      File(patchCount).writeAsStringSync("0");
    }

      String a=File(patchCount).readAsStringSync();
      print(a+"  DEBE EJECUTARSE UNA VEZ");

      return patchImages;
    }



   Future<String> get patchImagesInit async {//para establecer variable patchImages en constructor
    var directory = await getApplicationDocumentsDirectory();
    patchImages=directory.path+"/cartoon";
    return directory.path+"/cartoon";
  }

  ImageModel() {
    try{
      this.patchImagesInit;

      this.patchCountInit;

      this.verifyCount;
    }catch (e){

      File(patchCount).writeAsStringSync("0");
      String a=File(patchCount).readAsStringSync();

    }
  }

  Future getImage() async {
    //represent the results of asynchronous operations
    var image = await ImagePicker.pickImage(source: ImageSource
        .camera); //To suspend execution until a future completes

      _image = image;
      notifyListeners();
    var cartoon = await convertImage();//////////////////////////

      _cartoon = cartoon;////////////////////////
      print(_cartoon);
    notifyListeners();
  }

  convertImage() async{

    // Getting the absolute path to this script file
    //var currentPath = dirname(Platform.script.path);
    // Generating  absolute paths for the input/output images
    var pathImage=_image.path;


    var counterfile1 = File(patchCount);//recogemos valor almacenado
    String a=counterfile1.readAsStringSync();
    int i=int.parse(a);
    i = i+1;



    var pathCartoon= patchImages+i.toString()+".png";//donde se guardara el cartoon
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
          var f = await outputFile.writeAsBytes(imageResponse);//

          _temp=cartoon.toString();


          counterfile1.writeAsStringSync(i.toString());//actualizamos con +1 valor almacenado

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

  void onImageButtonPressed  () {

    notifyListeners();
  }


}//fin



