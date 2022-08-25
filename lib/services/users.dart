import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uname;
String? umail;
String? imageUrl;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await auth.signInWithCredential(credential);
  final User? user = authResult.user;

  assert (user?.email != null);
  assert (user?.displayName != null);
  assert (user?.photoURL != null);

  umail = user!.email;
  uname = user.displayName;
  imageUrl = user.photoURL;
  // print(umail);
  // print(uname);

  final User currentUser = auth.currentUser!;
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';

}

  void signOutGoogle() async {
  await googleSignIn.signOut();
  
  print('User Sign Out');
  }