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
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
