# Econva App

Aplicativo desenvolvido em Flutter utilizando **Clean Architecture**, **GetX** para gerenciamento de estado/injeção de dependências.

## Versao Do Flutter

├─────────┼─────────┼─────────────────┼──────────────┼──────────────┼────────┼───────┤
│ 3.27.1  │ stable  │ 3.27.1          │ 3.6.0        │ Dec 16, 2024 │        │ ●     │
├─────────┼─────────┼─────────────────┼──────────────┼──────────────┼────────┼───────┤

## Tecnologias

- Flutter
- Dart
- GetX
- Clean Architecture
- Material Design
📁 Estrutura do Projeto

## Arquitetura

O projeto utiliza uma estrutura baseada em Clean Architecture, separando responsabilidades entre as camadas.

lib/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   └── utils/
│
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   └── remote/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── presentation/
│   ├── bindings/
│   ├── controllers/
│   ├── pages/
│   └── widgets/
│
├── app.dart
└── main.dart