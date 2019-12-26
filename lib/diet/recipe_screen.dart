import 'package:flutter/material.dart';
import 'package:diabetes_app/diet/recipe.dart';
import 'package:webview_flutter/webview_flutter.dart';


class RecipeScreen extends StatefulWidget{

  final String mealType;
  final Recipe recipe;


  RecipeScreen({this.mealType, this.recipe});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();

}

class _RecipeScreenState extends State<RecipeScreen>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.mealType,style: TextStyle(
            color: Colors.black
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: WebView(
        initialUrl: widget.recipe.spoonacularSourceUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),

    );
  }

}