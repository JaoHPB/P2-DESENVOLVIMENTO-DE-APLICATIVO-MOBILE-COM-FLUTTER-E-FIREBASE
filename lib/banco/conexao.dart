import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../firebase_options.dart';

class Conexao {
  static Future<void> iniciar() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static DatabaseReference get tarefas {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://fir-un-6107e-default-rtdb.firebaseio.com',
    ).ref('tarefas/$uid');
  }
}
