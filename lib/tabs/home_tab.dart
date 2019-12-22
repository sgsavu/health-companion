import 'package:diabetes_app/login/auth_notifier.dart';
import 'package:diabetes_app/medicine/medicine_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>{


  @override
  Widget build(BuildContext context) {

    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network('https://cuteiphonewallpaper.com/wp-content/uploads/2019/06/iPhone-X-Home-Screen-Wallpaper.jpg',
            fit: BoxFit.cover,
          ),
          Scaffold(

            backgroundColor: Colors.transparent,

            appBar: AppBar(
              backgroundColor: Colors.white.withOpacity(0.6),
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0.0,
              title: Text(
                "Welcome back, ${authNotifier.user != null ? authNotifier.user.displayName : "Feed"}!", style: TextStyle(
                color: Colors.black,
              ),),
            ),

            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text("${authNotifier.user != null ? authNotifier.user.displayName : "Feed"}"),
                    accountEmail:Text("${authNotifier.user != null ? authNotifier.user.email : "Feed"}") ,
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/0/04/John_Legend_2019_by_Glenn_Francis.jpg'),
                    ),
                  ),
                  ListTile(
                    title: Text('About'),
                    trailing: Icon(Icons.info),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 5,
                  ),
                  ListTile(
                    title: Text('Logout'),
                    trailing: Icon(Icons.exit_to_app),
                    onTap: () => signout(authNotifier),
                  ),
                ],
              ),
            ),


          ),

        ],
      ),
    );

  }


}