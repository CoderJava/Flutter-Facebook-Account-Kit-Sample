import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final FacebookLogin facebookSignIn = FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
          Logged in!
          
          Token: ${accessToken.token}
          User id: ${accessToken.userId}
          Expires: ${accessToken.expires}
          Permissions: ${accessToken.permissions}
          Declined permissions: ${accessToken.declinedPermissions}
        ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Facebook Account Kit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_message),
            RaisedButton(
              child: Text('Log in'),
              onPressed: _login,
            ),
            RaisedButton(
              onPressed: _logOut,
              child: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
