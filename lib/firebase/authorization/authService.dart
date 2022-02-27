import 'package:live_streaming_flutter_app/firebase/database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> registerUser({email, name, pass, username, image}) async {

    var _auth = FirebaseAuth.instance;
    try {
      var userNameExists =
          await DatabaseService.checkUsername(username: username);
      if (!userNameExists) {
        return -1;
      }
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      var user = result.user;

      await FirebaseAuth.instance.currentUser!.updatePhotoURL(
       '/',
      );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(
        '$name',
      );
      await DatabaseService.regUser(
          name: name,
          email: email,
          username: username,
          image: image,
          uid: user!.uid);
      return 1;
    } catch (e) {
      switch (e.toString()) {
        case 'ERROR_INVALID_EMAIL':
          return -2;
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return -3;
          break;

        case 'ERROR_WEAK_PASSWORD':
          return -4;
          break;
      }
      return 0;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
