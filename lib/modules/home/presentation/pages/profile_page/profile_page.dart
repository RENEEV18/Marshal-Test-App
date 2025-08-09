import 'package:flutter/material.dart';
import 'package:marshal_test_app/core/const/colors/colors.dart';
import 'package:marshal_test_app/core/const/styles/styles.dart';
import 'package:marshal_test_app/core/utils/formatter.dart';
import 'package:marshal_test_app/core/utils/widgets/loader.dart';
import 'package:marshal_test_app/modules/auth/presentation/controllers/login_controller.dart';
import 'package:marshal_test_app/modules/home/presentation/widgets/profile_tile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<LoginController>(context, listen: false).getUserProfile(context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, login, child) {
        return login.state.isUserLoading
            ? Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CommonLoadingWidget(), Text("Loading profile...")],
              )
            : login.state.getUserList == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text("No data found! Something went wrong")],
                  )
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: AppColors.primaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppStyle.kHeight10,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  login.state.getUserList?.image ?? '',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                        child: CommonLoadingWidget(
                                          circleValue: progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Icon(
                                        Icons.person,
                                        size: 32,
                                        color: AppColors.primaryWhite.withValues(alpha: 0.6),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              AppStyle.kHeight10,
                              Text(
                                HelperFunction.checkValue(
                                    "${login.state.getUserList?.firstName} ${login.state.getUserList?.lastName}"),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppColors.primaryWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Text(
                                HelperFunction.checkValue(login.state.getUserList?.email),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryWhite,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              AppStyle.kHeight20,
                            ],
                          ),
                        ),
                        AppStyle.kHeight15,
                        Padding(
                          padding: AppPadding.scaffoldPadding,
                          child: Column(
                            spacing: 15,
                            children: [
                              ProfileInfoTile(
                                icon: Icons.person,
                                label: "Username",
                                value: login.state.getUserList?.username ?? "",
                              ),
                              ProfileInfoTile(
                                icon: Icons.phone,
                                label: "Phone",
                                value: login.state.getUserList?.phone ?? "",
                              ),
                              ProfileInfoTile(
                                icon: Icons.location_on,
                                label: "Address",
                                value:
                                    "${login.state.getUserList?.address?.address ?? ''}, ${login.state.getUserList?.address?.city ?? ''}, ${login.state.getUserList?.address?.state ?? ''}",
                              ),
                              ProfileInfoTile(
                                icon: Icons.work,
                                label: "Occupation",
                                value: login.state.getUserList?.company?.title ?? "",
                              ),
                              ProfileInfoTile(
                                icon: Icons.school,
                                label: "University",
                                value: login.state.getUserList?.university ?? "",
                              ),
                              ProfileInfoTile(
                                icon: Icons.cake,
                                label: "Date of Birth",
                                value: login.state.getUserList?.birthDate ?? "",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
      },
    );
  }
}
