import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthState { initial, loading, otpSent, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthState _state = AuthState.initial;
  String? _errorMessage;
  ConfirmationResult? _confirmationResult;
  User? _user;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _state == AuthState.loading;
  String? get phoneNumber => _user?.phoneNumber;

  AuthProvider() {
    _user = _auth.currentUser;
    if (_user != null) {
      _state = AuthState.authenticated;
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _confirmationResult = await _auth.signInWithPhoneNumber(
        phoneNumber.trim(),
      );
      _state = AuthState.otpSent;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? e.code;
      _state = AuthState.error;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
    }

    notifyListeners();
  }

  Future<bool> verifyOtp(String otp) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _confirmationResult!.confirm(otp.trim());
      _user = userCredential.user;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? e.code;
      _state = AuthState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _state = AuthState.initial;
    _confirmationResult = null;
    notifyListeners();
  }

  void resetState() {
    _state = AuthState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
