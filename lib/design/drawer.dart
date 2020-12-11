
import 'package:avataaar_image/avataaar_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:myapp/design/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatelessWidget{

  Map data;
  Function logoutCallback;
  HomeDrawer(this.data,this.logoutCallback);



@override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        child: Container(
          child: ListView(
          children: <Widget>[
             
      ListTile(
                    visualDensity: VisualDensity.compact,

        title: Text(data['email'].toString(),style: TextStyle(color:Colors.black,)),

      ),

      Divider(height: 0,),
          ListTile(
            visualDensity: VisualDensity.compact,
        leading: Icon(Ionicons.settings_outline,color: Colors.black,),
        title: Text('Settings'),
        onTap: () {
        
      },
      ),
            Divider(height: 0,),
                ListTile(
                              visualDensity: VisualDensity.compact,

        leading: Icon(Ionicons.mail_open_outline,color: Colors.black,),
        title: Text('Feedback',),
        onTap: () {
          _launchURL();
        },
      ),
      Divider(height: 0,),
                ListTile(
                              visualDensity: VisualDensity.compact,

        leading: Icon(Ionicons.information_circle_outline,color: Colors.black,),
        title: Text('About',),
        onTap: () {
        },
      ),
            Divider(height: 0,),
      ListTile(
                    visualDensity: VisualDensity.compact,

        leading: Icon(Ionicons.power_outline,color: Colors.black,),
        title: Text('Log Out',style: TextStyle(color:Colors.redAccent, )),
        onTap: () {
          logoutCallback();
        },
      ),
            Divider(height: 0,),

          ],
        )),
      );
  }


_launchURL() async {
  const url = 'mailto:<theharmonydesign@gmail.com>?subject=feedback&body=';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch any mail app';
  }
}
}