import 'package:flutter/material.dart';
import 'package:gitbbs/network/GitHttpRequest.dart';
import 'package:gitbbs/network/github/GithubHttpRequest.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPageContent(),
    );
  }
}

class LoginPageContent extends StatefulWidget {
  final GitHttpRequest request = GithubHttpRequest.getInstance();

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPageContent> {
  var _loading = false;
  var _formKey = new GlobalKey<FormState>();
  var _username = '';
  var _password = '';
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 40, top: 60, right: 40, bottom: 20),
            child: Column(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/github.png',
                    width: 100,
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                _formBuild(context),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                _buttonBuild(context)
              ],
            ),
          ),
        );
      }),
    );
  }

  _formBuild(context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10), labelText: 'GITHUB用户名'),
              onChanged: (username) {
                this._username = username;
              },
              controller: _usernameController,
            ),
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10), labelText: '登录密码'),
              onChanged: (password) {
                this._password = password;
              },
              controller: _passwordController,
              obscureText: true,
            )
          ],
        ));
  }

  _buttonBuild(context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: RaisedButton(
          onPressed: _onClick(context),
          color: Colors.blue,
          textColor: Colors.white,
          child: _loading
              ? Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('登录'),
        ))
      ],
    );
  }

  _onClick(context) {
    return () {
      if (_loading) {
        return;
      }
      if (_usernameController.text == '') {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('GITHUB用户名不得为空')));
        return;
      }
      if (_passwordController.text == '') {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('GITHUB密码不得为空')));
        return;
      }
      setState(() {
        _loading = true;
      });
      widget.request.signIn(_username, _password, (success) {
        if (success) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('登录成功')));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('登录失败')));
        }
        setState(() {
          _loading = false;
        });
        print('登录状态：' + success.toString());
      });
    };
  }
}
