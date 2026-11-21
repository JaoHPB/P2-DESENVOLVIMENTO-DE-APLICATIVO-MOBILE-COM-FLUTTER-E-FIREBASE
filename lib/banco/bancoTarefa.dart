import '../models/tarefa.dart';
import 'conexao.dart';

class BancoTarefa {
  static Stream<List<Tarefa>> listarTarefas() {
    return Conexao.tarefas.onValue.map((evento) {
      final valor = evento.snapshot.value;
      if (valor == null) {
        return <Tarefa>[];
      }

      final mapa = valor as Map;
      final lista = mapa.entries.map((item) {
        final dados = Map<String, dynamic>.from(item.value as Map);
        return Tarefa.fromMap(item.key as String, dados);
      }).toList();

      lista.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
      return lista;
    });
  }

  static Future<void> salvar(Tarefa tarefa) async {
    if (tarefa.id.isEmpty) {
      await Conexao.tarefas.push().set(tarefa.toMap());
    } else {
      await Conexao.tarefas.child(tarefa.id).set(tarefa.toMap());
    }
  }

  static Future<void> alterarSituacao(Tarefa tarefa) async {
    await Conexao.tarefas.child(tarefa.id).update({'concluida': !tarefa.concluida});
  }

  static Future<void> excluir(String id) async {
    await Conexao.tarefas.child(id).remove();
  }
}
