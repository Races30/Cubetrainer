import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cubetrainer/models/solve.dart';
import 'package:cubetrainer/providers/selected_cube_type.dart';
import 'scramble_screen.dart';
import 'timer_screen.dart';
import 'stats_screen.dart';
import 'coach_screen.dart';
import '../providers/session_provider.dart';
import '../services/solve_repository.dart';
import '../services/home_widget_helper.dart';
import '../utils/ios_platform_helper.dart';

class HomeNav extends ConsumerStatefulWidget {
  const HomeNav({super.key});

  @override
  ConsumerState<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends ConsumerState<HomeNav> {
  int _index = 0;

  List<Widget> get _pages => [
        const ScrambleScreen(),
        TimerScreen(cubeType: ref.watch(selectedCubeTypeProvider)),
        const StatsScreen(),
        const CoachScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    final selectedCubeType = ref.watch(selectedCubeTypeProvider);
    final activeSession = ref.watch(activeSessionProvider);
    final theme = Theme.of(context);

    // Sync stats with native home widget whenever solves change
    ref.listen(
        solvesProvider(cubeType: selectedCubeType, sessionId: activeSession),
        (prev, next) {
      HomeWidgetHelper.updateWidgetInfo(next, selectedCubeType);
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.25),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CubeType>(
              value: selectedCubeType,
              isDense: true,
              dropdownColor: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              iconEnabledColor: theme.colorScheme.primary,
              onChanged: (CubeType? newValue) {
                if (newValue != null) {
                  IosPlatformHelper.selectionClick();
                  ref.read(selectedCubeTypeProvider.notifier).state = newValue;
                }
              },
              items: CubeType.values
                  .map<DropdownMenuItem<CubeType>>((CubeType value) {
                return DropdownMenuItem<CubeType>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      value.label,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          if (_index != i) {
            FocusScope.of(context).unfocus();
            IosPlatformHelper.selectionClick();
            setState(() => _index = i);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.shuffle), label: 'Scramble'),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Timer'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.smart_toy), label: 'Coach'),
        ],
      ),
    );
  }
}
