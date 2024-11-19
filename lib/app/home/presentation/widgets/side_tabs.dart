import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:niza_coursework/di.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/values/color_manager.dart';
import '../../../../core/values/font_size_manager.dart';
import '../../../../core/values/string_manager.dart';
import '../../../authentication/domain/usecases/logout_usecase.dart';
import '../blocs/homepage_bloc/homepage_bloc.dart';

class SideTabs extends StatelessWidget {
  final bool smallscreen;
  final HomepageBloc homepageBloc;
  const SideTabs(
      {super.key, required this.homepageBloc, this.smallscreen = false});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocBuilder<HomepageBloc, HomepageState>(
        bloc: homepageBloc,
        builder: (context, state) {
          return Container(
            width: smallscreen ? 210.r : 150.r,
            color: smallscreen
                ? ColorManager.darkBlue
                : ColorManager.navyBlue.withOpacity(0.1),
            child: Column(
              children: [
                Gap(40.r),
                _tabs(themeData,
                    title: StringManager.home,
                    selected: state.homePageIndex == 0, onTap: () {
                  if (smallscreen) {
                    Navigator.pop(context);
                    if (state.homePageIndex == 2) {
                      context.pop();
                    }
                  } else {
                    homepageBloc.pageController2.jumpToPage(0);
                  }
                  homepageBloc.pageController.jumpToPage(0);
                  homepageBloc.add(const HomepageUpdateHomepageIndex(0));
                }),
                _tabs(themeData,
                    title: StringManager.config,
                    selected: state.homePageIndex == 1, onTap: () {
                  if (smallscreen) {
                    Navigator.pop(context);
                    if (state.homePageIndex == 2) {
                      context.pop();
                    }
                  } else {
                    homepageBloc.pageController2.jumpToPage(0);
                  }
                  homepageBloc.pageController.jumpToPage(1);
                  homepageBloc.add(const HomepageUpdateHomepageIndex(1));
                }),
                _tabs(themeData,
                    title: StringManager.plot,
                    selected: state.homePageIndex == 2, onTap: () {
                  if (smallscreen) {
                    Navigator.pop(context);
                    if (state.homePageIndex == 2) return;
                    context.pushNamed(RouteNames.plot, extra: homepageBloc);
                  } else {
                    homepageBloc.pageController2.jumpToPage(1);
                  }
                  homepageBloc.add(const HomepageUpdateHomepageIndex(2));
                }),
                _tabs(themeData, title: StringManager.logout, selected: false,
                    onTap: () async {
                  LogoutUseCase useCase = getIt();
                  await useCase.execute(params: null);
                }),
              ],
            ),
          );
        });
  }

  Widget _tabs(ThemeData themeData,
      {required String title,
      required void Function() onTap,
      required bool selected}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: selected
            ? ColorManager.blue.withOpacity(0.2)
            : ColorManager.transparent,
        width: double.infinity,
        padding:
            EdgeInsetsDirectional.symmetric(horizontal: 10.r, vertical: 15.r),
        child: Text(
          title,
          style: themeData.textTheme.bodyMedium!
              .copyWith(fontSize: FontSizeManager.f16),
        ),
      ),
    );
  }
}
