import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';
import 'animated_button.dart';

class EmptyStateIllustration extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final EmptyStateType type;

  const EmptyStateIllustration({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(type)
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),
            const SizedBox(height: 32),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms)
            .moveY(begin: 10, end: 0, delay: 200.ms, duration: 400.ms, curve: Curves.easeOut),
            
            const SizedBox(height: 16),
            
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 400.ms)
            .moveY(begin: 10, end: 0, delay: 400.ms, duration: 400.ms, curve: Curves.easeOut),
            
            const SizedBox(height: 32),
            
            AnimatedButton(
              onPressed: onButtonPressed,
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 600.ms, duration: 400.ms)
            .moveY(begin: 10, end: 0, delay: 600.ms, duration: 400.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIllustration(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.food:
        return _buildFoodIllustration();
      case EmptyStateType.recipe:
        return _buildRecipeIllustration();
      case EmptyStateType.progress:
        return _buildProgressIllustration();
      case EmptyStateType.mealPlan:
        return _buildMealPlanIllustration();
    }
  }
  
  Widget _buildFoodIllustration() {
    return CustomPaint(
      size: const Size(200, 200),
      painter: _FoodIllustrationPainter(),
    );
  }
  
  Widget _buildRecipeIllustration() {
    return CustomPaint(
      size: const Size(200, 200),
      painter: _RecipeIllustrationPainter(),
    );
  }
  
  Widget _buildProgressIllustration() {
    return CustomPaint(
      size: const Size(200, 200),
      painter: _ProgressIllustrationPainter(),
    );
  }
  
  Widget _buildMealPlanIllustration() {
    return CustomPaint(
      size: const Size(200, 200),
      painter: _MealPlanIllustrationPainter(),
    );
  }
}

enum EmptyStateType {
  food,
  recipe,
  progress,
  mealPlan,
}

// Custom painters for each illustration type
class _FoodIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Draw plate
    final platePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, platePaint);
    
    // Draw plate border
    final borderPaint = Paint()
      ..color = AppColors.lightGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, borderPaint);
    
    // Draw fork and knife
    final utensils = Paint()
      ..color = AppColors.accentOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    // Fork
    final forkStart = Offset(center.dx - radius * 0.5, center.dy + radius * 0.7);
    final forkEnd = Offset(center.dx - radius * 0.2, center.dy - radius * 0.7);
    canvas.drawLine(forkStart, forkEnd, utensils);
    
    // Fork tines
    for (var i = -2; i <= 2; i++) {
      final tineStart = Offset(forkEnd.dx + i * 4, forkEnd.dy);
      final tineEnd = Offset(forkEnd.dx + i * 4, forkEnd.dy - 15);
      canvas.drawLine(tineStart, tineEnd, utensils);
    }
    
    // Knife
    final knifeStart = Offset(center.dx + radius * 0.5, center.dy + radius * 0.7);
    final knifeEnd = Offset(center.dx + radius * 0.2, center.dy - radius * 0.7);
    canvas.drawLine(knifeStart, knifeEnd, utensils);
    
    // Knife blade
    final bladePath = Path()
      ..moveTo(knifeEnd.dx, knifeEnd.dy)
      ..lineTo(knifeEnd.dx + 10, knifeEnd.dy + 5)
      ..lineTo(knifeEnd.dx + 5, knifeEnd.dy + 20)
      ..close();
    
    final bladePaint = Paint()
      ..color = AppColors.accentOrange
      ..style = PaintingStyle.fill;
    canvas.drawPath(bladePath, bladePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RecipeIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw cookbook
    final bookPaint = Paint()
      ..color = AppColors.accentBlue
      ..style = PaintingStyle.fill;
    
    final bookRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.7,
      height: size.height * 0.8,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(bookRect, const Radius.circular(10)),
      bookPaint,
    );
    
    // Draw book spine
    final spinePaint = Paint()
      ..color = AppColors.accentBlue.withAlpha(179)
      ..style = PaintingStyle.fill;
    
    final spineRect = Rect.fromLTWH(
      bookRect.left - 10,
      bookRect.top,
      15,
      bookRect.height,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(spineRect, const Radius.circular(5)),
      spinePaint,
    );
    
    // Draw book pages
    final pagesPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final pagesRect = Rect.fromLTWH(
      bookRect.left + 10,
      bookRect.top + 10,
      bookRect.width - 20,
      bookRect.height - 20,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(pagesRect, const Radius.circular(5)),
      pagesPaint,
    );
    
    // Draw recipe lines
    final linePaint = Paint()
      ..color = AppColors.textLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (var i = 0; i < 6; i++) {
      final y = pagesRect.top + 20 + i * 15;
      canvas.drawLine(
        Offset(pagesRect.left + 15, y),
        Offset(pagesRect.right - 15, y),
        linePaint,
      );
    }
    
    // Draw recipe title
    final titlePaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawLine(
      Offset(pagesRect.left + 15, pagesRect.top + 10),
      Offset(pagesRect.right - 40, pagesRect.top + 10),
      titlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProgressIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Draw chart background
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, bgPaint);
    
    // Draw chart border
    final borderPaint = Paint()
      ..color = AppColors.textLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius, borderPaint);
    
    // Draw chart segments
    final segmentPaints = [
      Paint()..color = AppColors.primaryGreen,
      Paint()..color = AppColors.accentOrange,
      Paint()..color = AppColors.accentBlue,
    ];
    
    // Segment 1 (40%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Start at top (negative PI/2)
      2.5132, // 40% of circle (0.4 * 2 * PI)
      true,
      segmentPaints[0],
    );
    
    // Segment 2 (35%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.9424, // Start after segment 1
      2.1991, // 35% of circle (0.35 * 2 * PI)
      true,
      segmentPaints[1],
    );
    
    // Segment 3 (25%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.1415, // Start after segment 2
      1.5708, // 25% of circle (0.25 * 2 * PI)
      true,
      segmentPaints[2],
    );
    
    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.6, centerPaint);
    
    // Draw trend arrow
    final arrowPaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(center.dx, center.dy + 15),
      Offset(center.dx, center.dy - 15),
      arrowPaint,
    );
    
    canvas.drawLine(
      Offset(center.dx, center.dy - 15),
      Offset(center.dx - 10, center.dy - 5),
      arrowPaint,
    );
    
    canvas.drawLine(
      Offset(center.dx, center.dy - 15),
      Offset(center.dx + 10, center.dy - 5),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MealPlanIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw calendar background
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final calendarRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.8,
      height: size.height * 0.8,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(calendarRect, const Radius.circular(10)),
      bgPaint,
    );
    
    // Draw calendar border
    final borderPaint = Paint()
      ..color = AppColors.textLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(calendarRect, const Radius.circular(10)),
      borderPaint,
    );
    
    // Draw calendar header
    final headerPaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.fill;
    
    final headerRect = Rect.fromLTWH(
      calendarRect.left,
      calendarRect.top,
      calendarRect.width,
      30,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        headerRect,
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(10),
      ),
      headerPaint,
    );
    
    // Draw calendar grid
    final gridPaint = Paint()
      ..color = AppColors.textLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Horizontal lines
    for (var i = 1; i < 5; i++) {
      final y = calendarRect.top + 30 + i * ((calendarRect.height - 30) / 5);
      canvas.drawLine(
        Offset(calendarRect.left, y),
        Offset(calendarRect.right, y),
        gridPaint,
      );
    }
    
    // Vertical lines
    for (var i = 1; i < 7; i++) {
      final x = calendarRect.left + i * (calendarRect.width / 7);
      canvas.drawLine(
        Offset(x, calendarRect.top + 30),
        Offset(x, calendarRect.bottom),
        gridPaint,
      );
    }
    
    // Draw meal indicators
    final mealPaint = Paint()
      ..color = AppColors.accentOrange
      ..style = PaintingStyle.fill;
    
    // Draw a few meal indicators in different cells
    _drawMealIndicator(canvas, calendarRect, 2, 1, mealPaint);
    _drawMealIndicator(canvas, calendarRect, 4, 2, mealPaint);
    _drawMealIndicator(canvas, calendarRect, 1, 3, mealPaint);
    _drawMealIndicator(canvas, calendarRect, 5, 3, mealPaint);
    _drawMealIndicator(canvas, calendarRect, 3, 4, mealPaint);
  }
  
  void _drawMealIndicator(Canvas canvas, Rect calendarRect, int col, int row, Paint paint) {
    final cellWidth = calendarRect.width / 7;
    final cellHeight = (calendarRect.height - 30) / 5;
    
    final x = calendarRect.left + col * cellWidth + cellWidth / 2;
    final y = calendarRect.top + 30 + row * cellHeight + cellHeight / 2;
    
    canvas.drawCircle(Offset(x, y), 8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}