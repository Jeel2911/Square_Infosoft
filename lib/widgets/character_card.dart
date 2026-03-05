import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/character.dart';
import 'character_modal.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final int index;

  const CharacterCard({super.key, required this.character, required this.index});

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Scale: press down
  late Animation<double> _scale;
  // Border glow: flashes yellow on tap
  late Animation<double> _borderGlow;
  // Shimmer overlay: quick white flash
  late Animation<double> _shimmer;

  bool _entered = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Scale squishes down then springs back
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.96)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.96, end: 1.02)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.02, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
    ]).animate(_ctrl);

    // Border lights up yellow then fades
    _borderGlow = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_ctrl);

    // White shimmer flashes quickly then gone
    _shimmer = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.07)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.07, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 80,
      ),
    ]).animate(_ctrl);

    // Staggered entrance
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) setState(() => _entered = true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    HapticFeedback.lightImpact();
    _ctrl.forward(from: 0.0);
    // Open modal mid-animation so it feels snappy
    await Future.delayed(const Duration(milliseconds: 120));
    if (mounted) showCharacterModal(context, widget.character);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _entered ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _entered ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: _onTap,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1F),
                    borderRadius: BorderRadius.circular(14),
                    // Border flashes yellow on tap
                    border: Border.all(
                      color: Color.lerp(
                        Colors.white.withOpacity(0.06),
                        const Color(0xFFFFE81F),
                        _borderGlow.value,
                      )!,
                      width: 1,
                    ),
                    // Subtle yellow shadow on tap
                    boxShadow: _borderGlow.value > 0
                        ? [
                            BoxShadow(
                              color: const Color(0xFFFFE81F)
                                  .withOpacity(_borderGlow.value * 0.18),
                              blurRadius: 16,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        // Card content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          child: Row(
                            children: [
                              _InitialBadge(name: widget.character.name),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.character.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      widget.character.birthYear,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.35),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${widget.character.filmCount}',
                                    style: const TextStyle(
                                      color: Color(0xFFFFE81F),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'films',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // White shimmer overlay
                        if (_shimmer.value > 0)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(_shimmer.value),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InitialBadge extends StatelessWidget {
  final String name;
  const _InitialBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE81F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          name[0].toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFFFE81F),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}