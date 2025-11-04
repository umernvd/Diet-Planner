import 'package:flutter/material.dart';
import '../main.dart';
import '../models/food_item.dart';

class SwipeableFoodItem extends StatefulWidget {
  final FoodItem foodItem;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  
  const SwipeableFoodItem({
    super.key,
    required this.foodItem,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<SwipeableFoodItem> createState() => _SwipeableFoodItemState();
}

class _SwipeableFoodItemState extends State<SwipeableFoodItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.foodItem.id),
      background: _buildDeleteBackground(),
      secondaryBackground: _buildEditBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Delete action
          widget.onDelete();
          return true;
        } else {
          // Edit action
          widget.onEdit();
          return false; // Don't dismiss for edit
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Food icon with background
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 16),
              
              // Food details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.foodItem.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.foodItem.servingSizeGrams}g',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Calories
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.foodItem.calories} kcal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'P: ${widget.foodItem.protein}g  C: ${widget.foodItem.carbs}g  F: ${widget.foodItem.fat}g',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      color: Colors.red.shade400,
      child: const Row(
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: AppColors.accentBlue,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Edit',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.edit, color: Colors.white),
        ],
      ),
    );
  }
}