import 'package:europro/notification_screens/notification_screen.dart';
import 'package:europro/perfil_screens/perfil_screen.dart';
import 'package:europro/ranking_screens/ranking_sreen.dart';
import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart'; 

class ProjectKaizen extends StatefulWidget {
  const ProjectKaizen({super.key});

  @override
  State<ProjectKaizen> createState() => _ProjectKaizenState();
}

class _ProjectKaizenState extends State<ProjectKaizen> {
  final List<PlatformFile> _selectedFiles = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Image.asset('images/logoEuroPro.png', height: 40),
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
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Projeto ',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Kaizen',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(
                              0xFF00358E,
                            ), // Cor específica para Kaizen
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Seção Título
            const Text(
              'Título',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
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
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_descriptionController.text.length}/6000 caracteres',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                TextField(
                  controller: _descriptionController,
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
                onPressed: () {
                  // Implementar lógica de envio
                  if (_titleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, insira um título'),
                      ),
                    );
                    return;
                  }

                  // Aqui você pode enviar os dados para o servidor
                  print('Enviando proposta...');
                  print('Título: ${_titleController.text}');
                  print('Descrição: ${_descriptionController.text}');
                  print('Arquivos anexados: ${_selectedFiles.length}');
                },
                child: const Text(
                  'ENVIAR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
