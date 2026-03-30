import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../services/api_service.dart';

class TelaCadastro extends StatefulWidget {
  final Usuario? usuario;

  const TelaCadastro({super.key, this.usuario});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    // 🔥 SE FOR EDIÇÃO, PREENCHE OS CAMPOS
    if (widget.usuario != null) {
      _nomeController.text = widget.usuario!.nome;
      _emailController.text = widget.usuario!.email;
    }
  }

  Future<void> _salvarUsuario() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Usuario usuario = Usuario(
          id: widget.usuario?.id,
          nome: _nomeController.text,
          email: _emailController.text,
        );

        // DECIDE ENTRE POST OU PUT
        if (widget.usuario == null) {
          await _apiService.criarUsuario(usuario);
        } else {
          if (usuario.id != null) {
            await _apiService.atualizarUsuario(usuario);
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Salvo com sucesso!')),
          );

          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.usuario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Usuário' : 'Novo Usuário'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Preencha o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Preencha o e-mail' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarUsuario,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEdicao ? 'ATUALIZAR' : 'SALVAR',
                          style: const TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}