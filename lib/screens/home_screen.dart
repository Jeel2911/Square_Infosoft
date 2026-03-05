import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterProvider>().fetchCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111114),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Consumer<CharacterProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) return _buildLoader();
                  if (provider.hasError) return _buildError(provider);
                  return _buildContent(provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small label above
          const Text(
            'THE FORCE AWAKENS',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 3.5,
              color: Color(0xFFFFE81F),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          // Big title
          const Text(
            'Characters',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.0,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          // Thin separator line
          Container(height: 1, color: Colors.white.withOpacity(0.07)),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 28, height: 28,
            child: CircularProgressIndicator(
              color: Color(0xFFFFE81F),
              strokeWidth: 2,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.white38, fontSize: 13, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildError(CharacterProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white24, size: 44),
            const SizedBox(height: 20),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38, fontSize: 14, height: 1.7,
              ),
            ),
            const SizedBox(height: 28),
            _RetryButton(
              onTap: () => provider.fetchCharacters(page: provider.currentPage),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(CharacterProvider provider) {
    return Column(
      children: [
        // Page info
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
          child: Row(
            children: [
              Text(
                '${provider.totalCount} beings',
                style: const TextStyle(
                  color: Colors.white38, fontSize: 12, letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                '${provider.currentPage} / ${provider.totalPages}',
                style: const TextStyle(
                  color: Colors.white38, fontSize: 12, letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        // Character list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            itemCount: provider.characters.length,
            itemBuilder: (context, index) => CharacterCard(
              character: provider.characters[index],
              index: index,
            ),
          ),
        ),

        // Pagination
        _buildPagination(provider),
      ],
    );
  }

  Widget _buildPagination(CharacterProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
      ),
      child: Row(
        children: [
          _NavButton(
            label: '← Prev',
            enabled: provider.hasPreviousPage,
            filled: false,
            onTap: provider.previousPage,
          ),
          const Spacer(),
          // Page dots
          Row(
            children: List.generate(
              provider.totalPages > 9 ? 9 : provider.totalPages,
              (i) {
                final isActive = (i + 1) == provider.currentPage;
                return GestureDetector(
                  onTap: () => provider.fetchCharacters(page: i + 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: isActive
                          ? const Color(0xFFFFE81F)
                          : Colors.white.withOpacity(0.18),
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          _NavButton(
            label: 'Next →',
            enabled: provider.hasNextPage,
            filled: true,
            onTap: provider.nextPage,
          ),
        ],
      ),
    );
  }
}

// ── Small reusable retry button ───────────────────────────────────────────────
class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RetryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Try again',
          style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 0.5),
        ),
      ),
    );
  }
}

// ── Pagination nav button ─────────────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool filled;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.enabled,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: filled && enabled
                ? const Color(0xFFFFE81F)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: filled && enabled
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.15),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: filled && enabled ? Colors.black : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}