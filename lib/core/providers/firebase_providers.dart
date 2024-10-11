import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
final firebaseAuth=Provider((ref)=>FirebaseAuth.instance);

final firebaseStrorage=Provider((ref)=>FirebaseStorage.instance);

final firebaseclodFireStore=Provider((ref)=>FirebaseFirestore.instance);

final googleSignIn=Provider((ref)=>GoogleSignIn());
