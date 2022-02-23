import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_streaming_flutter_app/helper/users.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const liveCollection = 'liveuser';
  static const userCollection = 'users';
  static const emailCollection = 'user_email';
  final String uid;
  DatabaseService({required this.uid});

  Stream<user_email> get currentUserData {
    return _firestore
        .collection(emailCollection)
        .doc(uid)
        .snapshots()
        .map(_userData);
  }

  static Future<String> getImage({username}) async {
    final snapShot = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(username)
        .get();
    return snapShot.data()!['image'];
  }

  static Future<String> getName({username}) async {
    final snapShot = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(username)
        .get();
    return snapShot.data()!['name'];
  }

  static void createLiveUser({name, id, time, image}) async {
    final snapShot = await FirebaseFirestore.instance
        .collection(liveCollection)
        .doc(name)
        .get();
    if (snapShot.exists) {
      await FirebaseFirestore.instance
          .collection(liveCollection)
          .doc(name)
          .update({'name': name, 'channel': id, 'time': time, 'image': image});
    } else {
      await FirebaseFirestore.instance
          .collection(liveCollection)
          .doc(name)
          .set({'name': name, 'channel': id, 'time': time, 'image': image});
    }
  }

  static Future<bool> checkUsername({username}) async {
    final snapShot = await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(username)
        .get();
    if (snapShot.exists) {
      return false;
    }
    return true;
  }

  static void deleteUser({username}) async {
    await FirebaseFirestore.instance
        .collection('liveuser')
        .doc(username)
        .delete().then((value) => print("Successfully deleted"));
  }

  static Future<void> regUser({name, email, username, image, uid}) async {

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$email/${path.basename(image.path)}');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.then((res) {
      res.ref.getDownloadURL();
    }); //  Image Upload code

    await storageReference.getDownloadURL().then((fileURL) async {
      // To fetch the uploaded data's url
      try
      {
        await FirebaseFirestore.instance
            .collection(userCollection)
            .doc(username)
            .set({
          'name': name,
          'email': email,
          'username': username,
          'image': fileURL,
        });
        await FirebaseFirestore.instance
            .collection(emailCollection)
            .doc(uid)
            .set({
          'name': name,
          'email': email,
          'username': username,
          'image': fileURL,
        });

      }catch(e)
      {
        print("Error while uploading data to firebase ${e.toString()}");
      }
      return true;
    });
  }

  static void deleteLiveUser(name) async {
    try {
      await FirebaseFirestore.instance
          .collection(liveCollection)
          .doc(name)
          .delete();
    } catch (e) {
      print("Unable to delete the document" + e.toString());
    }
  }

  user_email _userData(DocumentSnapshot snapshot) {
    if (snapshot.data() != null) {
      return user_email(
        name: snapshot.data()!['name'],
        username: snapshot.data()!['username'],
        image: snapshot.data()!['image'],
        email: snapshot.data()!['email'],
      );
    } else {
      return user_email(
        username: "",
        name: "",
        email: "",
        image: "",
      );
    }
  }

  Future<String> addUser(String userName, String email) async {
    String retVal = "error";

    try {
      await _firestore
          .collection('usersData')
          .doc(uid)
          .set({'uid': uid, 'userName': userName, 'email': email});
      retVal = "success";
    } on PlatformException catch (e) {
      retVal = e.toString();
    }
    return retVal;
  }

  getUserChats(String itIsMyName) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('usersData', arrayContains: itIsMyName)
        .snapshots();
  }

}
