import 'package:firebase_auth/firebase_auth.dart';

import '../models/usuario.dart';

class BancoUsuario {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Usuario? _converter(User? user) {
    if (user == null) {
      return null;
    }
    final nome = user.displayName;
    return Usuario(
      uid: user.uid,
      nome: (nome != null && nome.isNotEmpty) ? nome : (user.email ?? ''),
      email: user.email ?? '',
    );
  }

  static Stream<Usuario?> get usuarioStream {
    return _auth.userChanges().map(_converter);
  }

  static Usuario? get usuarioAtual => _converter(_auth.currentUser);

  static Future<String?> cadastrar(
    String nome,
    String email,
    String senha,
  ) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await credencial.user?.updateDisplayName(nome);
      await credencial.user?.reload();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado';
        case 'weak-password':
          return 'A senha deve ter pelo menos 6 caracteres';
        case 'invalid-email':
          return 'E-mail inválido';
        case 'network-request-failed':
          return 'Sem conexão com a internet';
        default:
          return 'Erro ao cadastrar: ${e.message}';
      }
    }
  }

  static Future<String?> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'E-mail ou senha inválidos';
        case 'invalid-email':
          return 'E-mail inválido';
        case 'user-disabled':
          return 'Este usuário está desativado';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente novamente mais tarde';
        case 'network-request-failed':
          return 'Sem conexão com a internet';
        default:
          return 'Erro ao entrar: ${e.message}';
      }
    }
  }

  static Future<void> sair() async {
    await _auth.signOut();
  }
}
