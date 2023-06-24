import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//signIn function
Future<User?> signInWithGoogle() async {
  try {
    //signing in with google
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    //creating credentials for firebase
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    //signing in with credentials & making a user in firebase and getting user class
    final userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    //checking in on
    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);

    final User? currentUser = await _auth.currentUser;
    assert(currentUser!.uid == user!.uid);
    return user;
  } catch (e) {
    //print(e);
  }
}

void signOut() async {
  await googleSignIn.signOut();
  await _auth.signOut();
}
