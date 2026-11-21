import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../banco/bancoTarefa.dart';
import 'menuLateral.dart';
import 'formTarefa.dart';

class ListaTarefas extends StatefulWidget {
  const ListaTarefas({super.key});

  @override
  State<ListaTarefas> createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  late final Stream<List<Tarefa>> _tarefas = BancoTarefa.listarTarefas();

  Color _corPrioridade(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.alta:
        return Colors.red;
      case Prioridade.media:
        return Colors.orange;
      case Prioridade.baixa:
        return Colors.green;
    }
  }

  void _abrirFormulario([Tarefa? tarefa]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormTarefa(tarefa: tarefa),
      ),
    );
  }

  Future<void> _confirmarExclusao(Tarefa tarefa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja excluir "${tarefa.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmou != true) {
      return;
    }

    await BancoTarefa.excluir(tarefa.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa excluída com sucesso!')),
    );
  }

  void _mostrarDetalhes(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tarefa.titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tarefa.descricao.isEmpty ? 'Sem descrição' : tarefa.descricao),
            const SizedBox(height: 12),
            Text('Vencimento: ${tarefa.dataFormatada}'),
            Text('Prioridade: ${tarefa.prioridade.rotulo}'),
            Text('Situação: ${tarefa.situacao}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _confirmarExclusao(tarefa);
            },
            child: const Text('Excluir'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _abrirFormulario(tarefa);
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      drawer: const MenuLateral(atual: '/tarefas'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Tarefa>>(
        stream: _tarefas,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar as tarefas'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa cadastrada'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final tarefa = lista[index];
              return ListTile(
                leading: Icon(
                  Icons.flag,
                  color: _corPrioridade(tarefa.prioridade),
                ),
                title: Text(
                  tarefa.titulo,
                  style: TextStyle(
                    decoration:
                        tarefa.concluida ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  'Vence em ${tarefa.dataFormatada} • '
                  '${tarefa.prioridade.rotulo} • ${tarefa.situacao}',
                ),
                trailing: IconButton(
                  icon: Icon(
                    tarefa.concluida
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                  tooltip: tarefa.concluida
                      ? 'Marcar como pendente'
                      : 'Marcar como concluída',
                  onPressed: () => BancoTarefa.alterarSituacao(tarefa),
                ),
                onTap: () => _mostrarDetalhes(tarefa),
              );
            },
          );
        },
      ),
    );
  }
}
