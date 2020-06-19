import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    // if token isnt null returns true. else false
    return token != null;
  }

  String get token {
    // if it has an expiery date and expirary date isnt after current time, eg not expired
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }


  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAH6ksds4_w0eBVJgaTBlLzlFWX3WAratc';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      // err handling in 200 response. this is handled on auth screen
      // this will only be thrown on failed validation of data
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      // log user in
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // set expiry date from time passed from firebase
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // need seperate funcs to pass diff urls
  Future<void> signUp(String email, String password) async {
    await _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    await _authenticate(email, password, 'signInWithPassword');
  }
}
