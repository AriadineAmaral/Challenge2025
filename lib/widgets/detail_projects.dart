import 'package:europro/widgets/title_and_drawer.dart';
import 'package:flutter/material.dart';

class DetailProjects extends StatelessWidget {
  const DetailProjects({super.key});

  // Dados mockados com tipos explícitos
  final Map<String, dynamic> projeto = const {
    'nome': 'Projeto Kaizen',
    'titulo': 'Implementação de um Sistema de Reserva de Salas de Reunião',
    'descricao': 'Implementar um sistema online para agendamento e reserva de salas de reunião, facilitando a organização e evitando conflitos de horário.',
    'detalhes': [
      {
        'label': 'Plataforma:',
        'value': 'Utilizar uma plataforma online de agendamento (Ex: Google Calendar, Microsoft Outlook Calendar, ou software específico para reserva de recursos).'
      },
      {
        'label': 'Disponibilidade:',
        'value': 'Disponibilizar painéis digitais próximos às salas de reunião exibindo a programação do dia.'
      },
      {
        'label': 'Responsável:',
        'value': 'TI ou Administrativo.'
      }
    ],
    'anexos': [
      'Diagrama_fluxo.pdf',
      'Cronograma.xlsx',
      'Orçamento.docx'
    ],
    'status': 'Em análise',
    'dataEnvio': '15/05/2023'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Image.asset(
          'images/logoEuroPro.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      drawer: TitleAndDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cabeçalho centralizado
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Meus projetos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Nome do projeto centralizado
                Text(
                  projeto['nome'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00358E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Conteúdo em cards centralizados
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Título
                        const Text(
                          'Título:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          projeto['titulo'],
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Descrição
                        const Text(
                          'Descrição:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          projeto['descricao'],
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Detalhes
                        ...projeto['detalhes'].map<Widget>((detalhe) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Text(
                                detalhe['label'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                detalhe['value'],
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Anexos
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Anexos:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: projeto['anexos'].map<Widget>((arquivo) => ListTile(
                            leading: const Icon(Icons.attach_file, color: Colors.grey),
                            title: Text(arquivo, textAlign: TextAlign.center),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Visualizar $arquivo')),
                              );
                            },
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Data de envio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Enviado em: ${projeto['dataEnvio']}',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}