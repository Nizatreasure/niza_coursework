import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:niza_coursework/di.dart';

import '../../../../core/common/form_submission/form_submission.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_dialog.dart';
import '../../../../core/common/widgets/custom_input_field.dart';
import '../../../../core/values/color_manager.dart';
import '../../../../core/values/font_size_manager.dart';
import '../../../../core/values/string_manager.dart';
import '../blocs/homepage_bloc/homepage_bloc.dart';
import '../blocs/plot_bloc/plot_bloc.dart';
import '../widgets/side_tabs.dart';

part '../widgets/plot_widgets.dart';

class PlotPage extends StatefulWidget {
  final HomepageBloc homepageBloc;
  const PlotPage({super.key, required this.homepageBloc});

  @override
  State<PlotPage> createState() => _PlotPageState();
}

class _PlotPageState extends State<PlotPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    widget.homepageBloc.add(const HomepageUpdateSelectedTab(0));
    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocProvider<PlotBloc>(
      create: (context) => getIt(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(homepageBloc: widget.homepageBloc),
        backgroundColor: themeData.scaffoldBackgroundColor,
        body: Builder(builder: (context) {
          return BlocListener<PlotBloc, PlotState>(
            listener: (context, state) {
              if (state.status is SubmissionFailure) {
                showCustomDialog(
                  context,
                  title: StringManager.error,
                  confirmButtonText: StringManager.close,
                  body: (state.status as SubmissionFailure).exception.message!,
                );
              }
            },
            child: _buildBody(themeData, context),
          );
        }),
      ),
    );
  }

  Widget _buildBody(ThemeData themeData, BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.r, 30.r, 24.r, 20.r),
        child: _buildDisplay(themeData, context),
      ),
    );
  }

  Widget _buildDisplay(ThemeData themeData, BuildContext context) {
    PlotBloc bloc = context.read<PlotBloc>();
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                padding: EdgeInsetsDirectional.only(
                    end: 20.r, top: 10.r, bottom: 10.r),
                child: const Icon(Icons.menu, color: ColorManager.white),
              ),
            ),
            Text(StringManager.historicalTrend,
                style: themeData.textTheme.bodyLarge),
          ],
        ),
        Gap(20.r),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(15.r),
                Text(StringManager.from, style: themeData.textTheme.bodyMedium),
                Gap(10.r),
                CustomInputField(
                  hintText: StringManager.startDate,
                  textController: context.read<PlotBloc>().startDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? startDate = await _getDateTime(context);
                    if (startDate != null) {
                      bloc.add(PlotUpdateStartDateEvent(startDate));
                    }
                  },
                ),
                Gap(20.r),
                Text(StringManager.to, style: themeData.textTheme.bodyMedium),
                Gap(10.r),
                CustomInputField(
                  hintText: StringManager.endDate,
                  textController: context.read<PlotBloc>().endDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? endDate = await _getDateTime(context);
                    if (endDate != null) {
                      bloc.add(PlotUpdateEndDateEvent(endDate));
                    }
                  },
                ),
                Gap(30.r),
                BlocBuilder<HomepageBloc, HomepageState>(
                    bloc: widget.homepageBloc,
                    builder: (context, homePageState) {
                      return BlocBuilder<PlotBloc, PlotState>(
                          builder: (context, state) {
                        PlotBloc plotBloc = context.read<PlotBloc>();
                        return CustomButton(
                          text: StringManager.plotData,
                          onTap: state.startDate != null &&
                                  state.endDate != null &&
                                  plotBloc.endDateController.text.isNotEmpty &&
                                  plotBloc.startDateController.text.isNotEmpty
                              ? () {
                                  bloc.add(const PlotFetchDataEvent());
                                }
                              : null,
                        );
                      });
                    }),
                _buildHistoryPlot(themeData, MediaQuery.of(context).size.width),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
