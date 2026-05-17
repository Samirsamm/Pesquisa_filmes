# 🎬 Cine App

Um aplicativo de filmes desenvolvido em Flutter, com listagem de filmes populares, busca por título, tela de detalhes e sistema de favoritos salvos no dispositivo.

---

## 📱 Funcionalidades

- 🎞️ **Filmes populares** — exibe uma lista de filmes em destaque usando a API do TMDB
- 🔍 **Busca por filmes** — pesquise filmes pelo nome
- 📄 **Tela de detalhes** — visualize informações como título, sinopse, avaliação e imagem do filme
- ⭐ **Favoritos** — salve seus filmes favoritos localmente no celular
- 🗑️ **Remoção de favoritos** — remova filmes favoritos com gesto de deslizar
- 🖼️ **Cache de imagens** — carregamento otimizado dos pôsteres dos filmes
- 🔐 **Proteção da chave da API** — uso de variáveis de ambiente com `.env`
- ⚠️ **Tratamento de carregamento e erros** — feedback visual durante buscas e requisições

---

## 🛠️ Tecnologias utilizadas

| Tecnologia | Uso |
|---|---|
| [Flutter](https://flutter.dev) | Framework principal para desenvolvimento mobile |
| [Dart](https://dart.dev) | Linguagem de programação |
| [TMDB API](https://developer.themoviedb.org/docs) | Dados de filmes, imagens, avaliações e informações detalhadas |
| [http](https://pub.dev/packages/http) | Requisições à API |
| [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) | Proteção do token da API |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Salvamento local dos filmes favoritos |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | Carregamento e cache dos pôsteres dos filmes |

---

## 🚀 Como rodar o projeto

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado
- [Dart](https://dart.dev/get-dart) instalado
- Conta gratuita no [TMDB](https://www.themoviedb.org/) para obter o token da API
- Dispositivo Android, iOS ou emulador configurado

### Passo a passo

**1. Clone o repositório**
```bash
git clone https://github.com/Samirsamm/Pesquisa_filmes
cd pesquisa_filmes
```

**2. Instale as dependências**
```bash
flutter pub get
```

**3. Configure o token da API**

Crie um arquivo `.env` na raiz do projeto baseado no `.env.example`:

```bash
cp .env.example .env
```

Abra o `.env` e substitua pelo seu token do TMDB:

```env
TMDB_TOKEN=seu_token_aqui
```

> Use o **API Read Access Token** do TMDB, geralmente uma chave longa que começa com `eyJ`.

**4. Registre o arquivo `.env` no `pubspec.yaml`**

Verifique se o arquivo `.env` está registrado como asset:

```yaml
flutter:
  assets:
    - .env
```

**5. Rode o app**
```bash
flutter run
```

---

## 📁 Estrutura do projeto

```txt
cine_app/
├── lib/
│   ├── main.dart          # Entrada do app e configuração inicial
│   ├── models.dart        # Modelo de dados do filme
│   ├── servico.dart       # Comunicação com a API do TMDB
│   └── telas/
│       ├── home.dart      # Tela inicial com filmes populares e busca
│       ├── detalhes.dart  # Tela de detalhes do filme
│       └── favoritos.dart # Tela de filmes favoritos
├── .env.example           # Modelo do arquivo de variáveis de ambiente
├── .gitignore             # Arquivos ignorados pelo Git
└── pubspec.yaml           # Dependências e configurações do projeto
```

---

## 🔐 Variáveis de ambiente

Este projeto usa um arquivo `.env` para proteger o token da API. O arquivo `.env` **nunca deve ser enviado ao GitHub**.

Veja o `.env.example` para saber quais variáveis são necessárias:

```env
TMDB_TOKEN=seu_token_aqui
```

No `.gitignore`, mantenha:

```gitignore
.env
```

---

## 📖 O que aprendi neste projeto

- Consumo de API REST com o pacote `http`
- Manipulação de dados JSON no Dart
- Conversão de dados da API em modelos próprios
- Organização do projeto em arquivos separados por responsabilidade
- Uso de `async/await`, `Future` e `Future.wait()` para operações assíncronas
- Navegação entre telas com `Navigator.push()`
- Passagem de dados entre telas
- Criação de tela de detalhes com informações dinâmicas
- Persistência local de dados com `shared_preferences`
- Salvamento e remoção de filmes favoritos
- Uso de `CachedNetworkImage` para melhorar performance no carregamento de imagens
- Aplicação de boas práticas de segurança com variáveis de ambiente
- Estruturação de um projeto Flutter para portfólio no GitHub

---

## 🧠 Conceitos aplicados

- API REST
- JSON
- Programação assíncrona
- Componentização de interface
- Separação de responsabilidades
- Persistência local
- Cache de imagens
- Navegação entre telas
- Boas práticas com `.env` e `.gitignore`

---

## 🚧 Melhorias futuras

- Adicionar paginação na listagem de filmes
- Criar filtros por gênero
- Exibir trailers dos filmes
- Adicionar tela de filmes em cartaz
- Adicionar tela de filmes mais bem avaliados
- Implementar tema claro e escuro
- Melhorar a responsividade da interface
- Adicionar testes automatizados
- Publicar o app como projeto de portfólio

---

## 👨‍💻 Autor

Feito com 💙 por **Samirsamm**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Samirsamm)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/samuel-ddr/)

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
