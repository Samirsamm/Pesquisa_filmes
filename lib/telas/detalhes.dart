import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../servico.dart';

// ─── Tela de detalhes do filme ───────────────────────────────────────────────
class DetalhesPage extends StatefulWidget {
  final Filme filme;
  const DetalhesPage({super.key, required this.filme});

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  Map<String, dynamic>? _detalhes;
  bool _carregando = true;
  bool _favorito = false;

  @override
  void initState() {
    super.initState();
    _carregarDetalhes();
    _verificarFavorito();
  }

  Future<void> _carregarDetalhes() async {
    try {
      final detalhes = await FilmeServico.buscarDetalhes(widget.filme.id);
      setState(() { _detalhes = detalhes; });
    } catch (_) {} finally {
      setState(() { _carregando = false; });
    }
  }

  Future<void> _verificarFavorito() async {
    final fav = await FilmeServico.ehFavorito(widget.filme.id);
    setState(() { _favorito = fav; });
  }

  Future<void> _toggleFavorito() async {
    if (_favorito) {
      await FilmeServico.removerFavorito(widget.filme.id);
    } else {
      await FilmeServico.salvarFavorito(widget.filme);
    }
    setState(() { _favorito = !_favorito; });

    // Mostra um snackbar de confirmação
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _favorito ? 'Adicionado aos favoritos!' : 'Removido dos favoritos.',
          ),
          backgroundColor: _favorito ? const Color(0xFFE50914) : Colors.grey,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filme = widget.filme;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: CustomScrollView(
        slivers: [
          // AppBar com imagem de fundo (backdrop)
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF141414),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: _toggleFavorito,
                icon: Icon(
                  _favorito ? Icons.favorite : Icons.favorite_outline,
                  color: _favorito ? const Color(0xFFE50914) : Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Backdrop
                  filme.urlBackdrop.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: filme.urlBackdrop,
                          fit: BoxFit.cover,
                        )
                      : Container(color: const Color(0xFF2A2A2A)),

                  // Gradiente para o texto ficar legível
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF141414),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título e nota
                  Text(
                    filme.titulo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Informações rápidas
                  Row(
                    children: [
                      _buildTag(Icons.star, filme.notaFormatada, const Color(0xFFFFD700)),
                      const SizedBox(width: 12),
                      if (filme.ano.isNotEmpty)
                        _buildTag(Icons.calendar_today, filme.ano, Colors.white54),
                      const SizedBox(width: 12),
                      if (_detalhes != null && _detalhes!['runtime'] != null)
                        _buildTag(
                          Icons.access_time,
                          '${_detalhes!['runtime']} min',
                          Colors.white54,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Gêneros
                  if (_detalhes != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_detalhes!['genres'] as List? ?? [])
                          .map((g) => _buildGenero(g['name']))
                          .toList(),
                    ),

                  const SizedBox(height: 20),

                  // Tagline
                  if (_detalhes != null &&
                      (_detalhes!['tagline'] ?? '').isNotEmpty) ...[
                    Text(
                      '"${_detalhes!['tagline']}"',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Sinopse
                  const Text(
                    'Sinopse',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _carregando
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFFE50914)))
                      : Text(
                          filme.sinopse.isNotEmpty
                              ? filme.sinopse
                              : 'Sinopse não disponível.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icone, String texto, Color cor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, size: 16, color: cor),
        const SizedBox(width: 4),
        Text(texto, style: TextStyle(color: cor, fontSize: 14)),
      ],
    );
  }

  Widget _buildGenero(String nome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE50914).withOpacity(0.6)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        nome,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}
