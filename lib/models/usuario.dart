class Usuario {
  String uid;
  String nome;
  String email;

  Usuario({required this.uid, required this.nome, required this.email});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'nome': nome, 'email': email};
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'] as String,
      nome: map['nome'] as String,
      email: map['email'] as String,
    );
  }
}
