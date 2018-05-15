import 'package:flutter/material.dart';
import 'package:fluttery_hidden_drawer/menu_screen.dart';
import 'package:fluttery_hidden_drawer/other_screen.dart';
import 'package:fluttery_hidden_drawer/restaurant_screen.dart';
import 'package:fluttery_hidden_drawer/zoom_scaffold.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hidden Drawer Menu',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var activeScreen = restaurantScreen;
  var selectedItemId = 'restaurant';
  final menu = new Menu(
    items: [
      new MenuItems(
        id: 'restaurant',
        title: 'THE PADDOCK',
      ),
      new MenuItems(
        id: 'other1',
        title: 'THE HERO',
      ),
      new MenuItems(
        id: 'other2',
        title: 'HELP US GROW',
      ),
      new MenuItems(
        id: 'other3',
        title: 'SETTINGS',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
      menuScreen: new MenuScreen(
        menu: menu,
        selectedItemId: selectedItemId,
        onMenuItemSelected: (id) {
          selectedItemId = id;
          if (id == 'restaurant') {
            setState(() => activeScreen = restaurantScreen);
          } else {
            setState(() => activeScreen = otherScreen);
          }
        },
      ),
      contentScreen: activeScreen,
    );
  }
}

