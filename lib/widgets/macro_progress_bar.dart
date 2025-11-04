import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class MacroProgressBar extends StatelessWidget {
  final double proteinPct;
  final double carbsPct;
  final double fatPct;

  const MacroProgressBar({
    super.key,
    required this.proteinPct,
    required this.carbsPct,
    required this.fatPct,
  });

  Widget _buildBar(
    BuildContext context,
    Color color,
    double pct,
    String label,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const SizedBox(width: 8),
                Text(
                  label, 
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '${(pct * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // Background track
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            
            // Animated progress
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuart,
              height: 12,
              width: MediaQuery.of(context).size.width * pct.clamp(0.0, 1.0) * 0.7, // Adjust width based on parent
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms, color: Colors.white.withAlpha(51)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Macronutrients',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildBar(
              context,
              const Color(0xFF4CAF50), // Protein - Green
              proteinPct,
              'Protein',
              Icons.fitness_center,
            ),
            const SizedBox(height: 16),
            _buildBar(
              context,
              const Color(0xFFFFA000), // Carbs - Amber
              carbsPct,
              'Carbs',
              Icons.grain,
            ),
            const SizedBox(height: 16),
            _buildBar(
              context,
              const Color(0xFFF44336), // Fat - Red
              fatPct,
              'Fat',
              Icons.opacity,
            ),
          ],
        ),
      ),
    );
  }
}
