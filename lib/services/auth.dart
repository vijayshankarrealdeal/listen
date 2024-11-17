import 'dart:convert';
import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listen/widgets/error_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pincode_input_fields/pincode_input_fields.dart';

class Auth extends ChangeNotifier {
  Auth() {
    _getData();
  }
  final _auth = FirebaseAuth.instance;
  Stream<User?> authState() => _auth.authStateChanges();
  List<Coun> country = [];
  bool load = false;
  bool optNow = false;
  TextEditingController phoneNumber = TextEditingController();
  PincodeInputFieldsController valCon = PincodeInputFieldsController();
  TextEditingController searchText = TextEditingController();
  bool circleload = false;
  String verid = "";
  String searchRes = '';
  String cpuntryDefautl = '+91';

  void search(String s) {
    searchRes = s.toLowerCase();
    notifyListeners();
  }

  void submit(String s) {
    cpuntryDefautl = s;
    notifyListeners();
  }

  void changeNum() {
    optNow = false;
    load = false;
    verid = "";
    valCon.clear();
    phoneNumber.clear();
    notifyListeners();
  }

  void signout() async {
    await _auth.signOut();
  }

  Future<void> _getData() async {
    final response = await rootBundle.loadString('assets/CountryCodes.json');
    country = json.decode(response).map<Coun>((e) => Coun.fromJson(e)).toList();
    notifyListeners();
  }

  String phoneNum() {
    var mainS = phoneNumber.text;
    var coe = cpuntryDefautl;
    var firstFour = mainS.substring(0, 5);
    var third = mainS.substring(5, mainS.length);
    String total = '$coe $firstFour $third';
    return total;
  }

  bool resendAgain = false;
  void resend(BuildContext context) {
    resendAgain = true;
    notifyListeners();
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNum(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          errorAlert(context, e.message!);
          load = false;
          optNow = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          verid = verificationId;
          resendAgain = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String t) {
          log(t);
        });
  }

  void signInWithPhone(BuildContext context) async {
    load = true;
    notifyListeners();
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: phoneNum(),
          verificationCompleted: (x) async {
            await _auth.signInWithCredential(x);
          },
          verificationFailed: (e) {
            load = false;
            optNow = false;
            //errorAlert(context, e.toString());
            notifyListeners();
          },
          codeSent: (String verificationId, int? resendToken) {
            verid = verificationId;
            optNow = true;
            load = false;
            notifyListeners();
          },
          codeAutoRetrievalTimeout: (String t) {
            log(t);
          });
    } catch (e) {
      errorAlert(context, e.toString());
    }
  }

  void verifyOTP(String code) async {
    log(verid);
    load = true;
    notifyListeners();
    try {
      var cre = PhoneAuthProvider.credential(
        verificationId: verid,
        smsCode: code,
      );
      UserCredential userCred = await _auth.signInWithCredential(cre);
      if (userCred.user != null) {}
      load = false;
      optNow = false;
      valCon.clear();
      //phoneNumber.clear();
      notifyListeners();
    } catch (e) {
      load = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    circleload = true;
    notifyListeners();
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      circleload = false;
    } catch (e) {
      circleload = false;
    }
    notifyListeners();
  }
}

class Coun {
  final String name;
  final String code;
  final String letter;

  Coun({required this.name, required this.code, required this.letter});

  factory Coun.fromJson(Map<String, dynamic> data) {
    return Coun(
        name: data['name'], code: data['dial_code'], letter: data['code']);
  }
}
