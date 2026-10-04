import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../common/theme/astralia_colors.dart';
import '../../../common/theme/astralia_theme.dart';
import '../../../common/widgets/astralia_background.dart';
import '../controllers/home_controller.dart';
import '../widgets/coming_soon.dart';
import '../widgets/settings_sheet.dart';

/// Contenedor de las secciones principales con la barra de navegación inferior.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const _icons = {
    HomeTab.cosmos: Icons.wb_sunny_outlined,
    HomeTab.discover: Icons.explore_outlined,
    HomeTab.storm: Icons.bolt_outlined,
    HomeTab.community: Icons.groups_outlined,
    HomeTab.galaxy: Icons.auto_awesome_outlined,
  };

  String _label(AppLocalizations l10n, HomeTab tab) => switch (tab) {
    HomeTab.cosmos => l10n.navCosmos,
    HomeTab.discover => l10n.navDiscover,
    HomeTab.storm => l10n.navStorm,
    HomeTab.community => l10n.navCommunity,
    HomeTab.galaxy => l10n.navGalaxy,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: AstraliaBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: l10n.settings,
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AstraliaColors.gold,
                  ),
                  onPressed: () => showSettingsSheet(context),
                ),
              ),
              Expanded(
                child: Obx(
                  () => IndexedStack(
                    index: controller.tab.value.index,
                    children: [
                      for (final tab in HomeTab.values)
                        ComingSoon(title: _label(l10n, tab)),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Row(
                  children: [
                    for (final tab in HomeTab.values)
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.select(tab),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _icons[tab],
                                  size: 20,
                                  color: tab == controller.tab.value
                                      ? AstraliaColors.goldSoft
                                      : AstraliaColors.muted,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _label(l10n, tab),
                                  style: AstraliaType.sans(
                                    size: 9,
                                    color: tab == controller.tab.value
                                        ? AstraliaColors.goldSoft
                                        : AstraliaColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
