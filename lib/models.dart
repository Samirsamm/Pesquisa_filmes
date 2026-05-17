// ─── Modelo de dados ────────────────────────────────────────────────────────
//
// Essa classe representa um filme vindo da API do TMDB.
// O factory construtor fromJson transforma o Map do JSON em um objeto Dart.

class Filme {
  final int id;
  final String titulo;
  final String sinopse;
  final String poster;       // caminho do poster (ex: /abc123.jpg)
  final String backdrop;     // imagem de fundo para a tela de detalhes
  final double nota;
  final String lancamento;
  final List<int> generoIds;

  Filme({
    required this.id,
    required this.titulo,
    required this.sinopse,
    required this.poster,
    required this.backdrop,
    required this.nota,
    required this.lancamento,
    required this.generoIds,
  });

  // Converte o JSON da API para um objeto Filme
  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      id:         json['id'],
      titulo:     json['title'] ?? json['name'] ?? 'Sem título',
      sinopse:    json['overview'] ?? '',
      poster:     json['poster_path'] ?? '',
      backdrop:   json['backdrop_path'] ?? '',
      nota:       (json['vote_average'] ?? 0).toDouble(),
      lancamento: json['release_date'] ?? json['first_air_date'] ?? '',
      generoIds:  List<int>.from(json['genre_ids'] ?? []),
    );
  }

  // URL completa do poster para usar no Image.network
  String get urlPoster =>
      poster.isNotEmpty ? 'https://image.tmdb.org/t/p/w500$poster' : '';

  // URL da imagem de fundo (maior, para a tela de detalhes)
  String get urlBackdrop =>
      backdrop.isNotEmpty ? 'https://image.tmdb.org/t/p/w780$backdrop' : '';

  // Ano extraído da data de lançamento (ex: "2023-05-12" → "2023")
  String get ano =>
      lancamento.length >= 4 ? lancamento.substring(0, 4) : '';

  // Nota formatada com uma casa decimal (ex: 7.8)
  String get notaFormatada => nota.toStringAsFixed(1);

  // Serialização para salvar nos favoritos com shared_preferences
  Map<String, dynamic> toJson() => {
    'id':         id,
    'titulo':     titulo,
    'sinopse':    sinopse,
    'poster':     poster,
    'backdrop':   backdrop,
    'nota':       nota,
    'lancamento': lancamento,
    'generoIds':  generoIds,
  };
}

// ─── Mapa de gêneros ─────────────────────────────────────────────────────────
//
// O TMDB retorna IDs de gênero nos filmes. Esse mapa converte para nomes.

const Map<int, String> generos = {
  28:    'Ação',
  12:    'Aventura',
  16:    'Animação',
  35:    'Comédia',
  80:    'Crime',
  99:    'Documentário',
  18:    'Drama',
  10751: 'Família',
  14:    'Fantasia',
  36:    'História',
  27:    'Terror',
  10402: 'Música',
  9648:  'Mistério',
  10749: 'Romance',
  878:   'Ficção Científica',
  10770: 'Cinema TV',
  53:    'Suspense',
  10752: 'Guerra',
  37:    'Faroeste',
};
