import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/formatter.dart';
import 'package:marshal_test_app/core/utils/navigation.dart';
import 'package:marshal_test_app/core/utils/widgets/containers.dart';
import 'package:marshal_test_app/core/utils/widgets/listview.dart';
import 'package:marshal_test_app/core/utils/widgets/loader.dart';
import 'package:marshal_test_app/modules/home/presentation/controllers/home_controllers.dart';
import 'package:marshal_test_app/modules/home/presentation/pages/recipes_page/filter_recipe.dart';
import 'package:marshal_test_app/routes/route_constants.dart';
import 'package:provider/provider.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    final provider = Provider.of<HomeController>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getAllRecipe(
        context: context,
        limit: provider.state.limit,
        skip: provider.state.skip,
      );
    });

    // Pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!provider.state.isRecipeLoading) {
          provider.updateSkip(provider.state.skip + provider.state.limit);
          provider.getAllRecipe(
            context: context,
            limit: provider.state.limit,
            skip: provider.state.skip,
            searchQuery: provider.state.searchQuery,
            isLoadMore: true,
          );
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, home, child) {
        return home.state.isRecipeLoading && (home.state.recipeList?.recipes?.isEmpty ?? true)
            ? LoadingTextWidget(text: "Loading recipe...")
            : Padding(
                padding: AppPadding.scaffoldPadding,
                child: Column(
                  spacing: 20,
                  children: [
                    // Search bar & Filter button
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoSearchTextField(
                            controller: searchController,
                            placeholder: "Search recipes...",
                            onChanged: (value) => home.onSearchChanged(context, value),
                            onSuffixTap: () {
                              searchController.clear();
                              home.clearSearch(context);
                            },
                          ),
                        ),
                        AppStyle.kWidth10,
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: AppColors.primaryColor),
                          onPressed: () async {
                            home.initTempFilters();
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (_) => FilterBottomSheet(),
                            );
                          },
                        ),
                      ],
                    ),

                    // Recipes List
                    (home.state.recipeList?.recipes?.isEmpty ?? true)
                        ? EmptyWidget()
                        : Expanded(
                            child: Scrollbar(
                              controller: scrollController,
                              child: CommonListviewBuilder(
                                controller: scrollController,
                                separatorBuilder: (context, index) => AppStyle.kHeight10,
                                itemCount: (home.state.recipeList?.recipes?.length ?? 0) +
                                    (home.state.isRecipeLoading && (home.state.recipeList?.recipes?.isNotEmpty ?? false)
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  if (index == (home.state.recipeList?.recipes?.length ?? 0)) {
                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: CommonLoadingWidget()),
                                    );
                                  }

                                  var item = home.state.recipeList?.recipes?[index];
                                  return CommonListTile(
                                    elevation: 0,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    borderColor: AppColors.primaryWhite,
                                    borderRadius: 14,
                                    titleWidget: Row(
                                      children: [
                                        const Icon(Icons.fastfood),
                                        AppStyle.kWidth10,
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            HelperFunction.checkValue(item?.name),
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(Icons.delete, color: AppColors.primaryColor),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text('Delete Recipe'),
                                                  content: const Text('Are you sure you want to delete this recipe?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        AppNavigation().pop(context: context);
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(color: AppColors.primaryRed),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitleWidget: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: CommonContainerWithBorder(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          spacing: 10,
                                          children: [
                                            Text(
                                              "Ingredients",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(fontWeight: FontWeight.w500),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: item?.ingredients?.map(
                                                    (ingredient) {
                                                      return Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text("• "),
                                                          Expanded(
                                                            child: Text(
                                                              ingredient,
                                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                    fontWeight: FontWeight.w400,
                                                                    color:
                                                                        AppColors.primaryBlack.withValues(alpha: 0.7),
                                                                  ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ).toList() ??
                                                  [],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    isSubtitle: true,
                                    onTap: () {
                                      AppNavigation().pushNamed(
                                        context: context,
                                        route: AppRouteConstants.recipeDetailsRoute,
                                        arguments: item?.id,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              );
      },
    );
  }
}
