import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/gn_match_service.dart';

class MesMatchsTab extends StatefulWidget {
  const MesMatchsTab({super.key});

  @override
  State<MesMatchsTab> createState() => _MesMatchsTabState();
}

class _MesMatchsTabState extends State<MesMatchsTab> {
  final GnMatchService _service = GnMatchService();

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
    final favList = _service.matches.where((m) => _service.favMatchIds.contains(m.id)).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Mes Matchs Enregistrés', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: favList.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                child: const Column(
                  children: [
                    Icon(Icons.bookmark_border_rounded, size: 54, color: AppTheme.textSecondary),
                    SizedBox(height: 16),
                    Text('Aucun match enregistré', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Sélectionnez l\'icône étoile depuis l\'accueil pour conserver vos matchs ici.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${favList.length} rencontre(s) classée(s) par date', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 12),
                  ...favList.map((m) => Card(
                        color: AppTheme.surfaceCard,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                          subtitle: Text('${m.date} à ${m.time} • ${m.stadium}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m.score ?? m.status, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.star_rounded, color: AppTheme.primary),
                                onPressed: () => _service.toggleFavorite(m.id),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}
