import 'package:europro/data/repository/controller/project_kaizen_clic_controllers.dart';
import 'package:europro/data/repository/remote_projeto_repository.dart';
import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/projects_screens/project_kaizen_and_clic_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:diacritic/diacritic.dart'; 
import 'package:europro/projects_screens/my_projects_screen.dart';


class ProjectClic extends StatefulWidget {
  const ProjectClic({super.key});

  @override
  State<ProjectClic> createState() => _ProjectClicState();
}

class _ProjectClicState extends State<ProjectClic> {
  final List<PlatformFile> _selectedFiles = []; 
  final ProjectKaizenClicControllers _controllers =
      ProjectKaizenClicControllers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black,
        scrolledUnderElevation: 0,
        title: Image.asset('images/logoEuroPro.png', height: 30),
      ),
      drawer: TitleAndDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com botão voltar e título
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectKaizenAndClicScreen()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Expanded(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Projeto ',
                            style: GoogleFonts.akatab(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Clic',
                            style: GoogleFonts.akatab(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00358E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Seção Título
            Text(
              'Título',
              style: GoogleFonts.akatab(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controllers.tituloController,
              maxLength: 100,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Escreva um título para a sua idéia',
              ),
            ),
            const SizedBox(height: 16),

            // Seção Descrição
            Text(
              'Descrição',
              style: GoogleFonts.akatab(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_controllers.descricaoController.text.length}/6000 caracteres',
              style: GoogleFonts.kufam(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                TextField(
                  controller: _controllers.descricaoController,
                  maxLength: 6000,
                  maxLines: 8,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Escreva detalhes da sua idéia...',
                    contentPadding: const EdgeInsets.only(
                      bottom: 60,
                      left: 12,
                      right: 12,
                      top: 12,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 22,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: [
                      // Botão Anexar Arquivo
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.attach_file, size: 20),
                          label: const Text('Arquivos'),
                          onPressed: _pickFiles,
                          style: OutlinedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Botão Visualizar Arquivos
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.visibility, size: 20),
                          label: Text(
                            'Visualizar (${_selectedFiles.length})',
                          ), // Removido replaceAll desnecessário
                          onPressed: _viewFiles,
                          style: OutlinedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Botão Enviar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  final supabase = Supabase.instance.client;
                  final projetoRepo = RemoteProjetoRepository(client: supabase);

                  final titulo = _controllers.tituloController.text;
                  final descricao = _controllers.descricaoController.text;

                  if (titulo.isEmpty || descricao.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚠️ Por favor, preencha todos os campos',
                        style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Color(0xFFFFF200),
                      ),
                    );
                    return;
                  }

                  try {
                    final idProjeto = await projetoRepo.addProjeto(
                      titulo,
                      descricao,
                      '2',
                    );

                    for (final file in _selectedFiles) {
                      final fileBytes = file.bytes;
                      final fileName = sanitizeFileName(file.name);


                      if (fileBytes == null) {
                        print('Arquivo ${file.name} sem bytes, ignorando...');
                        continue;
                      }

                     final storagePath = 'projetos/$idProjeto/$fileName';


                      print('Fazendo upload do arquivo: $fileName');

                      final response = await supabase.storage
                          .from('arquivos')
                          .uploadBinary(
                            storagePath,
                            fileBytes,
                            fileOptions: const FileOptions(upsert: true),
                          );

                      print('Resposta do upload: $response');

                      if (response.isEmpty) {
                        print('Erro: resposta do upload está vazia');
                        continue;
                      }

                      final publicUrl = supabase.storage
                          .from('arquivos')
                          .getPublicUrl(storagePath);

                      print('URL pública do arquivo: $publicUrl');

                      await supabase.from('arquivos').insert({
                        'id_projeto': idProjeto,
                        'nome_arquivo': fileName,
                        'caminho': publicUrl,
                      });
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Inscrição finalizada com sucesso!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                      
                    );
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MyProjects()),
                    );
                  } catch (e) {
                    print('Erro no upload: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  'ENVIAR',
                  style: GoogleFonts.akatab(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Color(0xFF00358E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botão Notificações
            _buildSimpleNavIcon(
              icon: Icons.notifications_none,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  ),
            ),

            // Botão Home
            _buildSimpleNavIcon(
              icon: Icons.home_outlined,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RankingScreen()),
                  ),
            ),

            // Botão Perfil
            _buildSimpleNavIcon(
              icon: Icons.person_outline,
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PerfilScreen()),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleNavIcon({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      iconSize: 25, // Tamanho fixo (ajuste conforme necessário)
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ), // Espaçamento interno
      constraints: BoxConstraints(), // Remove restrições de tamanho padrão
      onPressed: onPressed,
    );
  }

  //Logica para escolher e enviar arquivos
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar arquivos: $e')),
      );
    }
  }

  void _viewFiles() {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nenhum arquivo anexado')));
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Arquivos Anexados'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = _selectedFiles[index];
                  return ListTile(
                    leading: Icon(_getFileIcon(file)),
                    title: Text(file.name),
                    subtitle: Text(
                      '${(file.size / 1024).toStringAsFixed(2)} KB',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFile(index),
                    ),
                    onTap: () => _openFile(file),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
    );
  }

  IconData _getFileIcon(PlatformFile file) {
    final extension = file.extension?.toLowerCase();
    if (extension == null) return Icons.insert_drive_file;

    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.videocam;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<void> _openFile(PlatformFile file) async {
    try {
      // Adicione verificação de null safety
      if (file.path != null) {
        await OpenFilex.open(file.path!); // Adicionado ! para garantir não-nulo
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arquivo sem caminho válido')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o arquivo: $e')),
      );
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }
  String sanitizeFileName(String fileName) {
  final cleaned = removeDiacritics(fileName); // remove acentos como ã, ç, etc
  return cleaned
      .replaceAll(RegExp(r'[^\w\s.-]'), '') // remove parênteses, %, &, etc
      .replaceAll(' ', '_') // troca espaços por underline
      .trim(); // remove espaços do início/fim
}
  }
