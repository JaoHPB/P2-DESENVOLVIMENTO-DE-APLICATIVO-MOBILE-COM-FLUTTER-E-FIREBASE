# Gerenciador de Tarefas

## Sobre o projeto

Este aplicativo foi desenvolvido para a P2 da disciplina de Programação Mobile, utilizando Flutter e Dart.

A ideia do projeto é permitir que o usuário organize suas tarefas do dia a dia. É possível criar uma conta, fazer login, cadastrar tarefas, editar, excluir e marcar como concluídas.

As informações são salvas no Firebase, permitindo que o usuário acesse suas tarefas mesmo depois de sair do aplicativo.

## Tecnologias utilizadas

- Flutter e Dart
- Firebase Authentication
- Firebase Realtime Database
- SharedPreferences

## Funcionalidades

O aplicativo possui cadastro e login de usuários, uma tela inicial que mostra a quantidade de tarefas e um menu lateral para acessar as outras telas.

No gerenciamento de tarefas, é possível cadastrar título, descrição, data de vencimento, prioridade e situação. Também é possível editar, excluir e marcar as tarefas como concluídas.

Outra funcionalidade é a opção de alterar entre o tema claro e escuro. Essa escolha fica salva no dispositivo utilizando SharedPreferences.

## Como executar

Para executar o projeto, é necessário ter o Flutter instalado e configurado.

Depois de abrir a pasta do projeto no VS Code, execute no terminal:

```bash
flutter pub get
```

O aplicativo também precisa estar configurado com o Firebase, com a autenticação por e-mail e senha ativada e o Realtime Database criado. É necessário configurar o `firebase_options.dart`, a URL do banco e as regras de acesso para cada usuário.

Com tudo configurado, execute:

```bash
flutter run -d chrome
```

## Organização dos arquivos

O projeto foi dividido em pastas para facilitar a organização:

- `models`: classes de usuário e tarefa.
- `telas`: telas do aplicativo.
- `banco`: conexão com Firebase e operações com os dados.
- `theme`: configuração dos temas.
- `main.dart`: arquivo principal do aplicativo.

## Considerações finais

Com esse projeto, foi possível trabalhar com Flutter, Firebase e armazenamento local. Também foi uma forma de praticar o cadastro de usuários, a navegação entre telas e o gerenciamento de informações em um banco de dados.