import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String _refreshToken;

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
      _refreshToken = responseData['refreshToken'];
      // set expiry date from time passed from firebase
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      // here is where user is officially logged in so this is where token timer starts
      _autoLogout();
      notifyListeners();
      // returns future that eventually returns shard pref instance
      final prefs = await SharedPreferences.getInstance();
      // prefs needs a string so we can create a JSON object to store
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          'refreshToken': _refreshToken
        },
      );
      // set a key and store here
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  // returns weather we were successful with our auto login
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _refreshToken = extractedUserData['refreshToken'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  // need seperate funcs to pass diff urls
  Future<void> signUp(String email, String password) async {
    await _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    await _authenticate(email, password, 'signInWithPassword');
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _refreshToken = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    // can use remove('userData') if there is data we want to persist
    prefs.clear();
    notifyListeners();
  }

  // auto refresh session
  Future<bool> _tryRefresh() async {
    // stop if refresh token is null
    if (_refreshToken == null) {
      return false;
    }
    // firebase refresh api
    final url =
        'https://securetoken.googleapis.com/v1/token?key=AIzaSyAH6ksds4_w0eBVJgaTBlLzlFWX3WAratc';
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'grant_type': 'refresh_token',
          'refresh_token': _refreshToken,
        },
      ),
    );

    final responseData = json.decode(response.body);
    // clear if error is returned from api
    if (responseData['error'] != null) {
      return false;
    }
    print("REFRESH TOKEN ${responseData['refresh_token']}");
    // log user in
    _token = responseData['id_token'];
    _userId = responseData['user_id'];
    _refreshToken = responseData['refresh_token'];
    // set expiry date from time passed from firebase
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseData['expires_in']),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    // prefs needs a string so we can create a JSON object to store
    final userData = json.encode(
      {
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'refreshToken': _refreshToken
      },
    );
    // set a key and store here
    prefs.setString('userData', userData);

    return true;
  }

  void tryRefreshOrLogout() async {
    final refreshBool = await _tryRefresh();

    if (!refreshBool) {
      logout();
    }

    _autoLogout();
    notifyListeners();
  }

  // need dart/async lib
  void _autoLogout() {
    // clear timer if one already exists
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    // set how long til token expires
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    // create timer to track the time in seconds
    _authTimer = Timer(Duration(seconds: timeToExpiry), tryRefreshOrLogout);
  }
}
