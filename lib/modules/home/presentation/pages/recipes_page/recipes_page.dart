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
import 'package:provider/provider.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    final provider = Provider.of<HomeController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        provider.getAllRecipe(context: context, limit: 10);
      },
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!provider.state.isRecipeLoading &&
            (provider.state.recipeList?.recipes?.length ?? 0) < (provider.state.recipeList?.total ?? 0)) {
          provider.getAllRecipe(
            context: context,
            limit: 10,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, home, child) {
        return home.state.isRecipeLoading && (home.state.recipeList?.recipes?.isEmpty ?? true)
            ? LoadingTextWidget(text: "Loading recipe...")
            : home.state.recipeList == null || home.state.recipeList?.recipes == []
                ? EmptyWidget()
                : Padding(
                    padding: AppPadding.scaffoldPadding,
                    child: Column(
                      spacing: 20,
                      children: [
                        CupertinoSearchTextField(),
                        Expanded(
                          child: Scrollbar(
                            controller: scrollController,
                            child: CommonListviewBuilder(
                              controller: scrollController,
                              separatorBuilder: (context, index) {
                                return AppStyle.kHeight10;
                              },
                              itemCount: (home.state.recipeList?.recipes?.length ?? 0) +
                                  (home.state.isRecipeLoading && (home.state.recipeList?.recipes?.isNotEmpty ?? false)
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                if (index == (home.state.recipeList?.recipes?.length ?? 0)) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CommonLoadingWidget(),
                                    ),
                                  );
                                }
                                var item = home.state.recipeList?.recipes?[index];
                                return CommonListTile(
                                  elevation: 0,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  borderColor: AppColors.primaryWhite,
                                  borderRadius: 14,
                                  titleWidget: Row(
                                    children: [
                                      Icon(Icons.fastfood),
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
                                                title: Text('Delete Recipe'),
                                                content: Text('Are you sure you want to delete this recipe?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      AppNavigation().pop(context: context);
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: AppColors.primaryRed,
                                                      ),
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
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: CommonContainerWithBorder(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 10,
                                        children: [
                                          Text(
                                            "ingredients",
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: item?.ingredients?.map(
                                                  (ingredient) {
                                                    return Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("• "),
                                                        Expanded(
                                                          child: Text(
                                                            ingredient,
                                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                  fontWeight: FontWeight.w400,
                                                                  color: AppColors.primaryBlack.withValues(alpha: 0.7),
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
