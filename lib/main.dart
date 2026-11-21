import 'package:flutter/material.dart';

import 'banco/conexao.dart';
import 'banco/preferencias.dart';
import 'telas/authGate.dart';
import 'telas/configuracoes.dart';
import 'telas/listaTarefas.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Conexao.iniciar();

  final escuro = await Preferencias.carregarTemaEscuro();
  AppTheme.modo.value = escuro ? ThemeMode.dark : ThemeMode.light;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.modo,
      builder: (context, modo, child) {
        return MaterialApp(
          title: 'Gerenciador de Tarefas',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: modo,
          home: const AuthGate(),
          routes: {
            '/tarefas': (context) => const ListaTarefas(),
            '/configuracoes': (context) => const Configuracoes(),
          },
        );
      },
    );
  }
}
