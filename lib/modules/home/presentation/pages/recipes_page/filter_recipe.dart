import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/core/utils/widgets/textforms.dart';
import 'package:marshal_test_app/modules/home/presentation/controllers/home_controllers.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, home, child) {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            home.clearTempFilters();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              AppStyle.kHeight20,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Filter by Tags",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AppNavigation().pop(context: context);
                    },
                    icon: Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: home.state.allTags.map((tag) {
                  final isSelected = home.tempSelectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    selectedColor: AppColors.primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primaryColor,
                    onSelected: (_) => home.toggleTempTag(tag),
                  );
                }).toList(),
              ),
              AppStyle.kHeight20,
              Text("Filter by Meal Type", style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: home.state.allMeals.map((meal) {
                  final isSelected = home.tempSelectedMeals.contains(meal);
                  return FilterChip(
                    label: Text(meal),
                    selected: isSelected,
                    selectedColor: AppColors.primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primaryColor,
                    onSelected: (_) => home.toggleTempMeal(meal),
                  );
                }).toList(),
              ),
              AppStyle.kHeight20,
              SizedBox(
                width: double.infinity,
                child: ButtonWidget(
                  text: "Apply Filters",
                  backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
                  onPressed: () {
                    home.applyTempFilters();
                    home.getAllRecipe(
                      context: context,
                      limit: home.state.limit,
                      skip: 0,
                      searchQuery: home.state.searchQuery,
                    );
                    AppNavigation().pop(context: context);
                  },
                ),
              ),
              AppStyle.kHeight30,
            ],
          ),
        ),
      );
    });
  }
}
