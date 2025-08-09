import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/images/images.dart';
import 'package:marshal_test_app/core/utils/widgets/listview.dart';
import 'package:marshal_test_app/modules/home/presentation/controllers/home_controllers.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeControllers>(
      builder: (context, home, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.primaryWhite,
            title: Text(
              home.state.titles[home.state.selectedIndex],
            ),
            centerTitle: true,
          ),
          drawer: Drawer(
            backgroundColor: AppColors.primaryWhite,
            child: Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                  child: Center(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            AppImages.splashImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                CommonListviewBuilder(
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: AppColors.primaryBlack.withValues(alpha: 0.08),
                    );
                  },
                  itemCount: home.state.titles.length,
                  itemBuilder: (context, index) {
                    return CommonListTile(
                      elevation: 0,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      borderColor: AppColors.primaryWhite,
                      borderRadius: 0,
                      leading: Icon(
                        home.drawerIcons[index],
                        size: 26,
                        color: AppColors.primaryColor,
                      ),
                      title: home.state.titles[index],
                      titleStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                      onTap: () {
                        home.changePageIndex(context: context, index: index);
                      },
                    );
                  },
                )
              ],
            ),
          ),
          body: SafeArea(
            child: home.pages[home.state.selectedIndex],
          ),
        );
      },
    );
  }
}
