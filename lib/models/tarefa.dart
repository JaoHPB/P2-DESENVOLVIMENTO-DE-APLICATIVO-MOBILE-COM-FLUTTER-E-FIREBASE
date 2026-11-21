enum Prioridade { baixa, media, alta }

extension PrioridadeRotulo on Prioridade {
  String get rotulo {
    switch (this) {
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Média';
      case Prioridade.alta:
        return 'Alta';
    }
  }
}

class Tarefa {
  String id;
  String titulo;
  String descricao;
  DateTime dataVencimento;
  Prioridade prioridade;
  bool concluida;

  Tarefa({
    this.id = '',
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    this.prioridade = Prioridade.media,
    this.concluida = false,
  });

  static String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  String get dataFormatada => formatarData(dataVencimento);

  String get situacao => concluida ? 'Concluída' : 'Pendente';

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'dataVencimento': dataVencimento.toIso8601String(),
      'prioridade': prioridade.name,
      'concluida': concluida,
    };
  }

  static Tarefa fromMap(String id, Map<String, dynamic> map) {
    return Tarefa(
      id: id,
      titulo: map['titulo'] as String,
      descricao: (map['descricao'] ?? '') as String,
      dataVencimento: DateTime.parse(map['dataVencimento'] as String),
      prioridade: Prioridade.values.firstWhere(
        (p) => p.name == map['prioridade'],
        orElse: () => Prioridade.media,
      ),
      concluida: (map['concluida'] ?? false) as bool,
    );
  }
}
