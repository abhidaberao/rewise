
import 'package:avataaar_image/avataaar_image.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';
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
                    

        title: Text(data['email'].toString(),style: TextStyle(color:Colors.black,)),

      ),

      Divider(height: 0,),
          ListTile(
        leading: Icon(Icons.settings,color: Colors.black,),
        title: Text('Settings'),
        onTap: () {
        
      },
      ),
            Divider(height: 0,),
                ListTile(

        leading: Icon(Icons.mail_outline,color: Colors.black,),
        title: Text('Feedback',),
        onTap: () {
          _launchURL();
        },
      ),
      Divider(height: 0,),
                ListTile(

        leading: Icon(Icons.info_outline,color: Colors.black,),
        title: Text('About',),
        onTap: () {
        },
      ),
            Divider(height: 0,),
      ListTile(

        leading: Icon(Icons.power,color: Colors.black,),
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
