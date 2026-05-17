import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

// ─── Serviço da API ──────────────────────────────────────────────────────────
//
// Toda comunicação com o TMDB fica aqui, separada da interface.
// Isso facilita muito a manutenção — se a API mudar, você altera só esse arquivo.

class FilmeServico {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Lê o token do .env e monta o cabeçalho de autenticação
  static Map<String, String> get _headers => {
    'Authorization': 'Bearer ${dotenv.env['TMDB_TOKEN'] ?? ''}',
    'Content-Type': 'application/json',
  };

  // ── Filmes populares ──────────────────────────────────────────────────────
  static Future<List<Filme>> buscarPopulares({int pagina = 1}) async {
    final url = Uri.parse(
      '$_baseUrl/movie/popular?language=pt-BR&page=$pagina',
    );

    final resposta = await http.get(url, headers: _headers);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar filmes populares.');
    }

    final json = jsonDecode(resposta.body);
    final List lista = json['results'];
    return lista.map((item) => Filme.fromJson(item)).toList();
  }

  // ── Busca por texto ───────────────────────────────────────────────────────
  static Future<List<Filme>> buscar(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      '$_baseUrl/search/movie'
      '?query=${Uri.encodeComponent(query)}&language=pt-BR&page=1',
    );

    final resposta = await http.get(url, headers: _headers);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar filmes.');
    }

    final json = jsonDecode(resposta.body);
    final List lista = json['results'];
    return lista.map((item) => Filme.fromJson(item)).toList();
  }

  // ── Detalhes completos de um filme ────────────────────────────────────────
  //
  // A rota /movie/{id} retorna mais informações do que a listagem,
  // como runtime, tagline e a lista completa de gêneros com nomes.

  static Future<Map<String, dynamic>> buscarDetalhes(int id) async {
    final url = Uri.parse('$_baseUrl/movie/$id?language=pt-BR');
    final resposta = await http.get(url, headers: _headers);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar detalhes do filme.');
    }

    return jsonDecode(resposta.body);
  }

  // ── Favoritos (salvo localmente com shared_preferences) ───────────────────
  //
  // Os favoritos ficam salvos no próprio celular, sem precisar de backend.
  // O shared_preferences funciona como um dicionário chave-valor persistente.

  static Future<List<Filme>> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> lista = prefs.getStringList('favoritos') ?? [];
    return lista
        .map((s) => Filme.fromJson(jsonDecode(s)))
        .toList();
  }

  static Future<void> salvarFavorito(Filme filme) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('favoritos') ?? [];

    // Evita duplicatas
    final jaExiste = lista.any((s) {
      final map = jsonDecode(s);
      return map['id'] == filme.id;
    });

    if (!jaExiste) {
      lista.add(jsonEncode(filme.toJson()));
      await prefs.setStringList('favoritos', lista);
    }
  }

  static Future<void> removerFavorito(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('favoritos') ?? [];
    lista.removeWhere((s) => jsonDecode(s)['id'] == id);
    await prefs.setStringList('favoritos', lista);
  }

  static Future<bool> ehFavorito(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('favoritos') ?? [];
    return lista.any((s) => jsonDecode(s)['id'] == id);
  }
}
