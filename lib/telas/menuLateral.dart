import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../banco/bancoUsuario.dart';

class MenuLateral extends StatelessWidget {
  final String atual;
  final Usuario? usuario;

  const MenuLateral({super.key, required this.atual, this.usuario});

  void _ir(BuildContext context, String rota) {
    final navigator = Navigator.of(context);
    navigator.pop();

    if (rota == atual) {
      return;
    }

    if (rota == '/') {
      navigator.popUntil((rotaAtual) => rotaAtual.isFirst);
    } else {
      navigator.pushNamedAndRemoveUntil(rota, (rotaAtual) => rotaAtual.isFirst);
    }
  }

  void _sobre(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    showAboutDialog(
      context: navigator.context,
      applicationName: 'Gerenciador de Tarefas',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.checklist, size: 40),
      children: const [
        Text(
          'Aplicativo desenvolvido em Flutter com Firebase '
          'Authentication e Realtime Database.',
        ),
      ],
    );
  }

  Future<void> _sair(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.popUntil((rotaAtual) => rotaAtual.isFirst);
    await BancoUsuario.sair();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final dados = usuario ?? BancoUsuario.usuarioAtual;
    final nome = dados?.nome ?? '';
    final email = dados?.email ?? '';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: tema.colorScheme.primary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: tema.textTheme.titleLarge?.copyWith(
                    color: tema.colorScheme.onPrimary,
                  ),
                ),
                Text(
                  email,
                  style: tema.textTheme.bodyMedium?.copyWith(
                    color: tema.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            selected: atual == '/',
            onTap: () => _ir(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Minhas tarefas'),
            selected: atual == '/tarefas',
            onTap: () => _ir(context, '/tarefas'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            selected: atual == '/configuracoes',
            onTap: () => _ir(context, '/configuracoes'),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre o aplicativo'),
            onTap: () => _sobre(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () => _sair(context),
          ),
        ],
      ),
    );
  }
}
