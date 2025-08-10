import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/widgets/containers.dart';
import 'package:marshal_test_app/core/utils/widgets/loader.dart';
import 'package:marshal_test_app/modules/home/presentation/controllers/home_controllers.dart';
import 'package:provider/provider.dart';

class RecipesDetails extends StatefulWidget {
  const RecipesDetails({super.key, required this.id});
  final int id;

  @override
  State<RecipesDetails> createState() => _RecipesDetailsState();
}

class _RecipesDetailsState extends State<RecipesDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<HomeController>(context, listen: false).getRecipeDetails(
          context: context,
          id: widget.id,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, home, child) {
        final details = home.state.recipeDetailsList;
        final isEdit = home.state.isEditMode;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.primaryWhite,
            title: Text("Recipe Details"),
            actions: [
              home.state.isRecipeUpdateLoading
                  ? CommonLoadingWidget(
                      circleColor: AppColors.primaryWhite,
                    )
                  : IconButton(
                      icon: Icon(isEdit ? Icons.check : Icons.edit),
                      onPressed: () async {
                        if (isEdit) {
                          await home.saveRecipe(context, widget.id);
                        } else {
                          home.toggleEditMode();
                        }
                      },
                    ),
            ],
          ),
          body: home.state.isRecipeDetailsLoading
              ? const Center(child: CommonLoadingWidget())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: CommonContainerWithBorder(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isEdit
                            ? TextField(
                                controller: home.state.nameController,
                                decoration: const InputDecoration(labelText: 'Recipe name'),
                              )
                            : Text(details?.name ?? '', style: Theme.of(context).textTheme.titleLarge),
                        AppStyle.kHeight15,
                        Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
                        AppStyle.kHeight10,
                        isEdit
                            ? Column(
                                children: [
                                  ...home.state.ingredientControllers.asMap().entries.map(
                                    (entry) {
                                      final idx = entry.key;
                                      final controller = entry.value;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: controller,
                                                decoration: InputDecoration(labelText: 'Ingredient ${idx + 1}'),
                                              ),
                                            ),
                                            AppStyle.kWidth10,
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () => home.removeIngredientField(idx),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  TextButton.icon(
                                    onPressed: home.addIngredientField,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add ingredient'),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: CommonContainerWithBorder(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: (details?.ingredients ?? []).map((ing) => Text('• $ing')).toList(),
                                  ),
                                ),
                              ),
                        AppStyle.kHeight15,
                        CommonContainerWithBorder(
                          child: Row(
                            children: [
                              Expanded(
                                child: isEdit
                                    ? TextField(
                                        controller: home.state.prepController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(labelText: 'Prep time (minutes)'),
                                      )
                                    : Text('Prep time: ${details?.prepTimeMinutes ?? '-'} minutes'),
                              ),
                              AppStyle.kWidth10,
                              Expanded(
                                child: isEdit
                                    ? TextField(
                                        controller: home.state.servingsController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(labelText: 'Servings'),
                                      )
                                    : Text('Servings: ${details?.servings ?? '-'}'),
                              ),
                            ],
                          ),
                        ),
                        AppStyle.kHeight20,
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
