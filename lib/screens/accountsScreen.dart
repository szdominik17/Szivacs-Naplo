import 'dart:async';
import 'package:flutter/material.dart';
import '../Datas/User.dart';
import '../GlobalDrawer.dart';
import '../globals.dart' as globals;
import '../Utils/AccountManager.dart';


void main() {
  runApp(new MaterialApp(home: new AccountsScreen()));
}

class AccountsScreen extends StatefulWidget {
  @override
  AccountsScreenState createState() => new AccountsScreenState();

}

class AccountsScreenState extends State<AccountsScreen> {

  void addPressed() {
    setState(() {
      Navigator.pushNamed(context, "/login");
    });

  }
  List<User> users;
  void _getUserList() async {
    users = await AccountManager().getUsers();
  }

  @override
  void initState() {

  super.initState();
    setState(() {
      _getUserList();
      _getListWidgets();
    });
  }

  void _getListWidgets() async {
    users = await AccountManager().getUsers();
    accountListWidgets = new List();
    for (User u in users) {
      setState(() {
        accountListWidgets.add(
          new ListTile(
            trailing: new FlatButton(onPressed: () {
              setState(() {
                _removeUserDialog(u);
              });
            },
                child: new Icon(Icons.close, color: Colors.red,)),
            title: new Text(u.name),
            leading: new Icon(Icons.person_outline),
          ),
        );
        accountListWidgets.add(new Divider(height: 1.0,),);
      });

    }
    accountListWidgets.add(new FlatButton(onPressed: addPressed, child: new Icon(Icons.add, color: Colors.blue,)));

  }

  Future<Null> _removeUserDialog(User user) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Biztos?"),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text("Törölni szeretnéd " + user.name + " felhasználót?"),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('nem'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('igen'),
              onPressed: () {
                setState(() {
                  AccountManager().removeUser(user);
                  _getListWidgets();
                  Navigator.of(context).pop();

                });
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> listItems() {
    _getUserList();
    List<Widget> widgetsList = new List();
    for (User u in users)
      widgetsList.add(
        new ListTile(
          trailing: new FlatButton(onPressed: () {
            setState(() {
              _removeUserDialog(u);
            });
          },
          child: new Icon(Icons.close, color: Colors.red,)),
          title: new Text(u.name),
          leading: new Icon(Icons.person_outline),
        ),
      );
    return widgetsList;
  }

  List<Widget> accountListWidgets;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () {
        globals.screen = 0;
        Navigator.pushReplacementNamed(context, "/main");
      },
        child: Scaffold(
            drawer: GlobalDrawer(context),
            appBar: new AppBar(
              title: new Text("Fiókok"),
              actions: <Widget>[
              ],
              /* bottom: new PreferredSize(
              child: new LinearProgressIndicator(
                value: 0.7,
              ),
              preferredSize: null),*/
            ),
            body: new Container(
              child: new Center(
                child: new Container(
                  child: accountListWidgets != null ? new ListView(
                    children:  accountListWidgets ,
                  ) : new CircularProgressIndicator()
                ),
              ),
            ),
        ),
    );
  }
}
