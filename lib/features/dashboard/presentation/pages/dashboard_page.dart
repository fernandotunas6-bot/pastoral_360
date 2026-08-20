import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_scaffold.dart';
import '../widgets/stat_card.dart';
import '../widgets/chart_card.dart';
import '../widgets/activity_list.dart';

/// DASHBOARD PAGE - PASTORAL 360
/// Preserva 100% o modelo visual do flutter-starter-app com a lógica do admin dashboard
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedPastorId = 1;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: const Text('Pastoral 360 - Painel Executivo'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Welcome Header (starter app style)
            Text(
              'Bom dia, Secretário Ministerial',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Text(
              'Missão das Igrejas Adventistas do 7º Dia - União Sudoeste de Angola (MCASD 2026)',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // Stat Cards Grid (using starter app StatCard visual widget)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isWide ? 2.2 : 1.5,
                  children: const [
                    StatCard(
                      title: 'TOTAL PASTORES',
                      value: '100',
                      icon: Icons.person,
                      color: Colors.blue,
                    ),
                    StatCard(
                      title: 'CONGREGAÇÕES',
                      value: '330',
                      icon: Icons.church,
                      color: Colors.amber,
                    ),
                    StatCard(
                      title: 'MÉDIA DA MISSÃO',
                      value: '4.52',
                      icon: Icons.star,
                      color: Colors.green,
                    ),
                    StatCard(
                      title: 'CLASSIFICAÇÃO',
                      value: 'MUITO BOM',
                      icon: Icons.emoji_events,
                      color: Colors.purple,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Admin Logic: Fast Lookup Card & Area Performance
            Row(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                // Fast Lookup Card
                Expanded(
                  flex: 3,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          const Text(
                            '🔍 Consulta Rápida de Pastor (Admin Logic)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: _selectedPastorId,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Pastor Mapeado',
                            ),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('1. Pr. Enoque Paulino (Presidente)')),
                              DropdownMenuItem(value: 2, child: Text('2. Pr. Florindo Chiconjo (Secretário)')),
                              DropdownMenuItem(value: 3, child: Text('3. Anc Simão Avelino (Tesoureiro)')),
                              DropdownMenuItem(value: 4, child: Text('4. Pr. Lauriano Salote (Andulo)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedPastorId = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: const Column(
                              children: [
                                _LookupRow(label: 'Distrito / Função', value: 'Presidente - Missão'),
                                _LookupRow(label: 'Província', value: 'Huambo'),
                                _LookupRow(label: 'Contacto', value: '924242887'),
                                Divider(),
                                _LookupRow(label: 'Pontuação Total', value: '245 / 255'),
                                _LookupRow(label: 'Média Geral', value: '4.80 (Excelente)'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 24),

                // Area Performance Bars
                Expanded(
                  flex: 4,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          const Text(
                            '📊 Desempenho Global por Área (51 Critérios)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          const _AreaBar(label: '1. Assistência Pastoral (11 Itens)', score: 4.65),
                          const _AreaBar(label: '2. Relacionamento Pessoal (11 Itens)', score: 4.70),
                          const _AreaBar(label: '3. Família Pastoral (5 Itens)', score: 4.60),
                          const _AreaBar(label: '4. Sermões e Doutrina (8 Itens)', score: 4.75),
                          const _AreaBar(label: '5. Administração Distrital (16 Itens)', score: 4.65),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LookupRow extends StatelessWidget {
  final String label;
  final String value;
  const _LookupRow({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class _AreaBar extends StatelessWidget {
  final String label;
  final double score;
  const _AreaBar({Key? key, required this.label, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(score.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: score / 5.0,
            backgroundColor: Colors.white10,
            color: Colors.blue,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}