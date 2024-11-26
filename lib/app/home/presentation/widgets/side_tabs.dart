import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:niza_coursework/core/routes/route_names.dart';
import 'package:niza_coursework/di.dart';

import '../../../../core/values/color_manager.dart';
import '../../../../core/values/font_size_manager.dart';
import '../../../../core/values/string_manager.dart';
import '../../../authentication/domain/usecases/logout_usecase.dart';
import '../blocs/homepage_bloc/homepage_bloc.dart';

class AppDrawer extends StatelessWidget {
  final HomepageBloc homepageBloc;
  const AppDrawer({super.key, required this.homepageBloc});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocBuilder<HomepageBloc, HomepageState>(
        bloc: homepageBloc,
        builder: (context, state) {
          return Container(
            width: 250.r,
            color: ColorManager.darkBlue,
            child: Column(
              children: [
                Gap(40.r),
                _tabs(themeData,
                    title: StringManager.home,
                    selected: state.selectedTab == 0, onTap: () {
                  if (state.selectedTab == 0) {
                    context.pop();
                    return;
                  }
                  homepageBloc.add(const HomepageUpdateSelectedTab(0));
                  while (context.canPop()) {
                    context.pop();
                  }
                }),
                _tabs(themeData,
                    title: StringManager.energy,
                    selected: state.selectedTab == 1, onTap: () {
                  if (state.selectedTab == 1) {
                    context.pop();
                    return;
                  }
                  homepageBloc.add(const HomepageUpdateSelectedTab(1));
                  while (context.canPop()) {
                    context.pop();
                  }
                  context.pushNamed(RouteNames.energy, extra: homepageBloc);
                }),
                _tabs(themeData,
                    title: StringManager.plot,
                    selected: state.selectedTab == 2, onTap: () {
                  if (state.selectedTab == 2) {
                    context.pop();
                    return;
                  }
                  homepageBloc.add(const HomepageUpdateSelectedTab(2));
                  while (context.canPop()) {
                    context.pop();
                  }
                  context.pushNamed(RouteNames.plot, extra: homepageBloc);
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
