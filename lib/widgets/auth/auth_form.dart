import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _userName = "";

  void _submit() {
    final bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      print("Email: " + _email);
      print("User name: " + _userName);
      print("Password: " + _password);
      print("Is login: $_isLogin");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: ValueKey("email"),
                  validator: (val) {
                    if (val.isEmpty ||
                        !val.contains("@") ||
                        !val.contains(".")) {
                      return "Pleas enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (val) => _email = val,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email address"),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey("userName"),
                    validator: (val) {
                      if (val.isEmpty || val.length < 4) {
                        return "Pleas enter at least 4 characters";
                      }
                      return null;
                    },
                    onSaved: (val) => _userName = val,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "User Name"),
                  ),
                TextFormField(
                  key: ValueKey("password"),
                  validator: (val) {
                    if (val.isEmpty || val.length < 7) {
                      return "Password must be at least 7 charecter";
                    }
                    return null;
                  },
                  onSaved: (val) => _password = val,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text(_isLogin ? "Login" : "Signup"),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _isLogin = !_isLogin;
                  }),
                  child: Text(
                    _isLogin
                        ? "Create new account"
                        : "I already have an account",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
