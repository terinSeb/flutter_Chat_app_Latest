import 'dart:io';

import 'package:chat_app_flutter/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.submitFn});

  final void Function(
      String email,
      String password,
      String username,
      // ignore: non_constant_identifier_names
      File Image,
      bool isLogin,
      BuildContext ctx) submitFn;

  final bool isLoading = false;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _userName = '';
  var _userEmail = '';
  var _userPass = '';
  var _isLogin = true;
  File? _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  final _formKey = GlobalKey<FormState>();
  void _trySubmit() {
    // ignore: no_leading_underscores_for_local_identifiers

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    // ignore: unnecessary_null_comparison
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an Image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState?.save();
      widget.submitFn(_userEmail.trim(), _userPass.trim(), _userName.trim(),
          _userImageFile!, _isLogin, context);
      // debugPrint(_userName);
      // debugPrint(_userEmail);
      // debugPrint(_userPass);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(imagePickerFn: _pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: ((newValue) {
                        _userEmail = newValue!;
                      }),
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'Email Address'),
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter atleast 4 characters';
                          }
                          return null;
                        },
                        onSaved: ((newValue) {
                          _userName = newValue!;
                        }),
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                      ),
                    TextFormField(
                      key: const ValueKey('pass'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      onSaved: ((newValue) {
                        _userPass = newValue!;
                      }),
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Signup')),
                    if (!widget.isLoading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have a account.'),
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
