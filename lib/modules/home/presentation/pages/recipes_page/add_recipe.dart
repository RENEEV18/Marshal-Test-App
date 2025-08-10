// add_recipe_sheet.dart
import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/core/utils/snackbar.dart';
import 'package:marshal_test_app/core/utils/widgets/textforms.dart';
import 'package:marshal_test_app/modules/home/presentation/controllers/home_controllers.dart';
import 'package:provider/provider.dart';

class AddRecipeBottomSheet extends StatelessWidget {
  const AddRecipeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, home, _) {
      final entity = home.state;

      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                ),
                AppStyle.kHeight15,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add Recipe',
                        style: Theme.of(context).textTheme.titleLarge,
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
                AppStyle.kHeight10,
                TextFormField(
                    controller: entity.addNameController, decoration: const InputDecoration(labelText: 'Name')),
                AppStyle.kHeight8,
                Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
                AppStyle.kHeight8,
                Column(
                  children: entity.addIngredientControllers.asMap().entries.map((e) {
                    final i = e.key;
                    final ctrl = e.value;
                    return Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                                controller: ctrl, decoration: InputDecoration(labelText: 'Ingredient ${i + 1}'))),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => home.removeRecipeIngredientField(i)),
                      ],
                    );
                  }).toList(),
                ),
                TextButton.icon(
                    onPressed: home.addRecipeIngredientField,
                    icon: const Icon(Icons.add),
                    label: const Text('Add ingredient')),
                AppStyle.kHeight8,
                Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Column(
                  children: entity.addInstructionControllers.asMap().entries.map((e) {
                    final i = e.key;
                    final ctrl = e.value;
                    return Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                                controller: ctrl, decoration: InputDecoration(labelText: 'Step ${i + 1}'))),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => home.removeInstructionField(i)),
                      ],
                    );
                  }).toList(),
                ),
                TextButton.icon(
                    onPressed: home.addInstructionField, icon: const Icon(Icons.add), label: const Text('Add step')),
                AppStyle.kHeight8,
                Row(children: [
                  Expanded(
                      child: TextFormField(
                          controller: entity.addPrepController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Prep (min)'))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: TextFormField(
                          controller: entity.addCookController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Cook (min)'))),
                ]),
                AppStyle.kHeight8,
                Row(children: [
                  Expanded(
                      child: TextFormField(
                          controller: entity.addServingsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Servings'))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: TextFormField(
                          controller: entity.addCaloriesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Calories'))),
                ]),
                AppStyle.kHeight8,
                TextFormField(
                    controller: entity.addDifficultyController,
                    decoration: const InputDecoration(labelText: 'Difficulty')),
                AppStyle.kHeight8,
                TextFormField(
                    controller: entity.addCuisineController, decoration: const InputDecoration(labelText: 'Cuisine')),
                AppStyle.kHeight8,
                TextFormField(
                    controller: entity.addTagsController,
                    decoration: const InputDecoration(labelText: 'Tags (comma separated)')),
                AppStyle.kHeight8,
                TextFormField(
                    controller: entity.addImageController, decoration: const InputDecoration(labelText: 'Image URL')),
                AppStyle.kHeight10,
                Text('Meal Type', style: Theme.of(context).textTheme.titleMedium),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: home.state.allMeals.map((meal) {
                    final selected = home.state.addSelectedMeals.contains(meal);
                    return FilterChip(
                        label: Text(meal), selected: selected, onSelected: (_) => home.toggleAddMealType(meal));
                  }).toList(),
                ),
                AppStyle.kHeight20,
                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    text: 'Add Recipe',
                    isLoading: home.state.isRecipeAddLoading,
                    backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
                    opacity: entity.addNameController.text.trim().isEmpty ? 0.4 : 1,
                    onPressed: home.state.isRecipeAddLoading
                        ? null
                        : () async {
                            // simple validation
                            if (entity.addNameController.text.trim().isEmpty) {
                              AppSnackbar.show(context, message: "Please enter a name", type: SnackbarType.error);
                              return;
                            }
                            await home.addRecipe(context: context);
                          },
                  ),
                ),
                AppStyle.kHeight30,
              ],
            ),
          ),
        ),
      );
    });
  }
}
