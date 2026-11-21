import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../models/usuario.dart';
import '../banco/bancoTarefa.dart';
import 'menuLateral.dart';
import 'formTarefa.dart';

class HomePage extends StatefulWidget {
  final Usuario usuario;

  const HomePage({super.key, required this.usuario});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Stream<List<Tarefa>> _tarefas = BancoTarefa.listarTarefas();

  Widget _cartao(
    BuildContext context,
    String titulo,
    int valor,
    IconData icone,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icone),
              const SizedBox(height: 8),
              Text('$valor', style: Theme.of(context).textTheme.headlineMedium),
              Text(titulo),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: MenuLateral(atual: '/', usuario: widget.usuario),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${widget.usuario.nome}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Tarefa>>(
              stream: _tarefas,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('Erro ao carregar tarefas: ${snapshot.error}');
                  return Text('Erro ao carregar as tarefas: ${snapshot.error}');
                }
                final lista = snapshot.data ?? [];
                final concluidas = lista.where((t) => t.concluida).length;
                final pendentes = lista.length - concluidas;

                return Row(
                  children: [
                    _cartao(
                      context,
                      'Cadastradas',
                      lista.length,
                      Icons.list_alt,
                    ),
                    _cartao(
                      context,
                      'Pendentes',
                      pendentes,
                      Icons.pending_actions,
                    ),
                    _cartao(
                      context,
                      'Concluídas',
                      concluidas,
                      Icons.check_circle,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/tarefas'),
                icon: const Icon(Icons.checklist),
                label: const Text('Minhas tarefas'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormTarefa()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Nova tarefa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
