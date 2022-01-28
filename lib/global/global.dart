import 'package:firebase_auth/firebase_auth.dart';
import 'package:kilometry_user/models/user_model.dart';

FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
