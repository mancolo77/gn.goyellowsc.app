import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/gn_match_service.dart';

class AccueilTab extends StatefulWidget {
  const AccueilTab({super.key});

  @override
  State<AccueilTab> createState() => _AccueilTabState();
}

class _AccueilTabState extends State<AccueilTab> {
  final GnMatchService _service = GnMatchService();
  String _selectedDate = 'Tous';
  String _statusFilter = 'Tous';

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hero = _service.getNearestMatch();
    var list = _service.matches;

    if (_selectedDate != 'Tous') {
      list = list.where((m) => m.date == _selectedDate).toList();
    }

    if (_statusFilter == 'À venir') {
      list = list.where((m) => !m.isFinished).toList();
    } else if (_statusFilter == 'Terminés') {
      list = list.where((m) => m.isFinished).toList();
    }

    final dates = ['Tous', 'Hier', 'Aujourd\'hui', 'Demain', '28 Oct', '24 Oct'];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Football Guinée', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
            child: const Center(
              child: Text('Ligue 1', style: TextStyle(color: AppTheme.buttonTextDark, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disclaimer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Text(
                'Données fictives — démonstration',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),

            // Hero Card
            if (hero != null) ...[
              const Text('Affiche Principale', style: TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildHeroCard(context, hero),
              const SizedBox(height: 16),
            ],

            // Date selector with yellow badges
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dates.map((d) {
                  final isSel = _selectedDate == d;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(d),
                      selected: isSel,
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.surfaceCard,
                      labelStyle: TextStyle(
                        color: isSel ? AppTheme.buttonTextDark : AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() => _selectedDate = d),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Status filters
            Row(
              children: ['Tous', 'À venir', 'Terminés'].map((st) {
                final isSel = _statusFilter == st;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ElevatedButton(
                      onPressed: () => setState(() => _statusFilter = st),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSel ? AppTheme.primary : AppTheme.surfaceCard,
                        foregroundColor: isSel ? AppTheme.buttonTextDark : Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                      ),
                      child: Text(st, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Compact Match List
            const Text('Toutes les Rencontres', style: TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (list.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                child: const Text('Aucun match pour cette sélection.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              )
            else
              ...list.map((m) => _buildCompactCard(context, m)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, GnMatch m) {
    final isFav = _service.favMatchIds.contains(m.id);
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: () => _showMatchDetails(context, m),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(6)),
                    child: Text(m.tour, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(6)),
                        child: Text(m.date, style: const TextStyle(color: AppTheme.buttonTextDark, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _service.toggleFavorite(m.id),
                        child: Icon(isFav ? Icons.star_rounded : Icons.star_outline_rounded, color: isFav ? AppTheme.primary : AppTheme.textSecondary, size: 24),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.filterBg,
                          child: Text(m.codeA, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        const SizedBox(height: 6),
                        Text(m.teamA, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: m.score != null
                        ? Text(m.score!, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))
                        : Text(m.time, style: const TextStyle(color: AppTheme.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.filterBg,
                          child: Text(m.codeB, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        const SizedBox(height: 6),
                        Text(m.teamB, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: AppTheme.border, height: 24),
              Text(m.summary, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context, GnMatch m) {
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => _showMatchDetails(context, m),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        title: Text('${m.teamA} — ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('${m.tour} • ${m.date} à ${m.time}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        trailing: Text(m.score ?? m.status, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  void _showMatchDetails(BuildContext context, GnMatch m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${m.tour} • ${m.date}', style: const TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  m.score != null ? '${m.teamA}  ${m.score}  ${m.teamB}' : '${m.teamA}  vs  ${m.teamB}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(m.stadium, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text('${m.time} • Statut : ${m.status}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
              const Divider(color: AppTheme.border, height: 20),
              Text(m.summary, style: const TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(height: 14),
              const Center(child: Text('Données fictives — démonstration', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontStyle: FontStyle.italic))),
            ],
          ),
        );
      },
    );
  }
}

