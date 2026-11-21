import 'package:flutter/material.dart';

import '../banco/preferencias.dart';
import '../theme/app_theme.dart';
import 'menuLateral.dart';

class Configuracoes extends StatelessWidget {
  const Configuracoes({super.key});

  Future<void> _alterarTema(bool escuro) async {
    AppTheme.modo.value = escuro ? ThemeMode.dark : ThemeMode.light;
    await Preferencias.salvarTemaEscuro(escuro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      drawer: const MenuLateral(atual: '/configuracoes'),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: AppTheme.modo,
        builder: (context, modo, child) {
          return ListView(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Tema escuro'),
                subtitle: const Text('A escolha fica salva no aparelho'),
                value: modo == ThemeMode.dark,
                onChanged: _alterarTema,
              ),
            ],
          );
        },
      ),
    );
  }
}
