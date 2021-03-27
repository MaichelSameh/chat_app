import 'package:flutter/material.dart';

typedef AuthenticationEmailFunction = void Function(String email,
    String password, String userName, bool isLogin, BuildContext ctx);

class AuthForm extends StatefulWidget {
  final AuthenticationEmailFunction submitAuth;
  final _isloading;

  const AuthForm(this.submitAuth, this._isloading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _userName = "";

  void _submit(BuildContext ctx) {
    final bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitAuth(
          _email.trim(), _password.trim(), _userName.trim(), _isLogin, ctx);
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
                if (widget._isloading) CircularProgressIndicator(),
                if (!widget._isloading)
                  Builder(
                    builder: (ctx) => ElevatedButton(
                      onPressed: () {
                        _submit(ctx);
                      },
                      child: Text(_isLogin ? "Login" : "Signup"),
                    ),
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
