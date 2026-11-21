import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../banco/bancoUsuario.dart';
import 'home.dart';
import 'login.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Stream<Usuario?> _usuario = BancoUsuario.usuarioStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Usuario?>(
      stream: _usuario,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final usuario = snapshot.data;
        if (usuario == null) {
          return const Login();
        }

        return HomePage(usuario: usuario);
      },
    );
  }
}
