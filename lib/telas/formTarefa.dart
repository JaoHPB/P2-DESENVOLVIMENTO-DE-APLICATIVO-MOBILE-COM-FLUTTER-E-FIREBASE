import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../banco/bancoTarefa.dart';

class FormTarefa extends StatefulWidget {
  final Tarefa? tarefa;

  const FormTarefa({super.key, this.tarefa});

  @override
  State<FormTarefa> createState() => _FormTarefaState();
}

class _FormTarefaState extends State<FormTarefa> {
  final _formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();

  DateTime? dataVencimento;
  Prioridade prioridade = Prioridade.media;
  bool concluida = false;
  bool salvando = false;

  bool get editando => widget.tarefa != null;

  @override
  void initState() {
    super.initState();
    final tarefa = widget.tarefa;
    if (tarefa != null) {
      tituloController.text = tarefa.titulo;
      descricaoController.text = tarefa.descricao;
      dataVencimento = tarefa.dataVencimento;
      dataController.text = tarefa.dataFormatada;
      prioridade = tarefa.prioridade;
      concluida = tarefa.concluida;
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    dataController.dispose();
    super.dispose();
  }

  Future<void> escolherData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: dataVencimento ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (escolhida != null) {
      setState(() {
        dataVencimento = escolhida;
        dataController.text = Tarefa.formatarData(escolhida);
      });
    }
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => salvando = true);

    final tarefa = Tarefa(
      id: widget.tarefa?.id ?? '',
      titulo: tituloController.text.trim(),
      descricao: descricaoController.text.trim(),
      dataVencimento: dataVencimento!,
      prioridade: prioridade,
      concluida: concluida,
    );

    try {
      await BancoTarefa.salvar(tarefa);
    } catch (e) {
      if (!mounted) return;
      setState(() => salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar a tarefa: $e')),
      );
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          editando
              ? 'Tarefa atualizada com sucesso!'
              : 'Tarefa cadastrada com sucesso!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar tarefa' : 'Nova tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: dataController,
                readOnly: true,
                onTap: escolherData,
                decoration: const InputDecoration(
                  labelText: 'Data de vencimento',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (dataVencimento == null) {
                    return 'Informe a data de vencimento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Prioridade'),
              const SizedBox(height: 8),
              SegmentedButton<Prioridade>(
                segments: const [
                  ButtonSegment(value: Prioridade.baixa, label: Text('Baixa')),
                  ButtonSegment(value: Prioridade.media, label: Text('Média')),
                  ButtonSegment(value: Prioridade.alta, label: Text('Alta')),
                ],
                selected: {prioridade},
                onSelectionChanged: (selecao) {
                  setState(() => prioridade = selecao.first);
                },
              ),
              const SizedBox(height: 16),
              const Text('Situação'),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Pendente')),
                  ButtonSegment(value: true, label: Text('Concluída')),
                ],
                selected: {concluida},
                onSelectionChanged: (selecao) {
                  setState(() => concluida = selecao.first);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: salvando ? null : salvar,
                  child: Text(editando ? 'Atualizar' : 'Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
