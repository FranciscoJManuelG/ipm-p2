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
import 'package:ipm_p2/model.dart';
import 'dart:async';

//fin
//void main() => runApp(new MyHomePage());
void main() {
  runApp(MyApp(
    model: ImageModel(),
  ));
}
///////////////////////////////////////

class CartoonImages {

  //-- image
  final String image;


  CartoonImages({ this.image});


  static List<CartoonImages> addimages(String patch,int num) {
    var allimages = new List<CartoonImages>();

    for( var i = 1 ; i <= num; i=i+1 ) {
      allimages.add(new CartoonImages( image: patch + i.toString() + ".png"));
    }

    return allimages;
  }
}

class HomePage extends StatelessWidget {
  List<CartoonImages> _allimages;
  int count;
  String patch;

  void passParameters(int count,String patch){
    this.count=count;
    this.patch=patch;
    _allimages=CartoonImages.addimages(patch, count);

  }

  @override

  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Gallery",
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: getHomePageBody(context))

    );
  }

  getHomePageBody(BuildContext context) {

    return ListView.builder(
      itemCount: count,//pasas el tamaño de la lista
      itemBuilder: _getItemUI,//la operacion que se hara con cada elemento
      padding: EdgeInsets.all(0.0),//**
    );
  }
  // First Attempt
  Widget _getItemUI(BuildContext context, int index) {

    print("llegar llega aqui"+_allimages[index].image);
    return new Image.asset(

      _allimages[index].image,
      fit: BoxFit.cover,
      width: 100.0,
    );


  }
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
        title: 'Converter2Picture',
        home: View(), ////////////////////////
      ),
    );
  }
}

class View extends StatelessWidget {
  HomePage homepage=new HomePage();
  var _mode_gallery=false;
  String patch;
  int count;

  void obtainData() async{
     count = await ImageModel.count;
     patch = await ImageModel.localPathname;

     homepage.passParameters(count, patch);

  }

  @override
  Widget build(BuildContext context1) {

    return  Scaffold(
      appBar: new AppBar(
        title: new Text('Converter2Picture'),
      ),
      body: ScopedModelDescendant<ImageModel>(
        builder: (context, child, model) {
          ////
          if(_mode_gallery==true) {
              return  homepage;
          }else {
            return Center(
              child: model.cartoon == null
                  ? new Text('No se ha realizado ninguna fotografía')
                  : new Image.file(model.cartoon),
            );
          }

        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ScopedModelDescendant<ImageModel>(
            builder: (context, child, model) {
              return FloatingActionButton(
                onPressed: (){
              _mode_gallery=false;
              model.getImage();
              model.onImageButtonPressed();
                },
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
                  onPressed:() {
                    _mode_gallery=false;
                    model.shareImage();
                    model.onImageButtonPressed();

                  },
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
                  tooltip: 'Gallery',
                  child: new Icon(Icons.photo_library),
                    onPressed:()async {
                      await obtainData();//este await hara que pueda ejecutarse antes de cargar los witgets
                      _mode_gallery=true;
                      model.onImageButtonPressed();


                      //homepage.passParameters(count, patch);

                    }

                ),
              );
            },
          ),
        ],
      ),
    );
  }




}//fin


