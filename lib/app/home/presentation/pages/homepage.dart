import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:niza_coursework/app/home/presentation/pages/plot.dart';
import 'package:niza_coursework/core/common/widgets/custom_button.dart';
import 'package:niza_coursework/core/common/widgets/custom_dropdown.dart';

import '../../../../core/common/enums/enums.dart';
import '../../../../core/common/widgets/custom_circle_painter.dart';
import '../../../../core/common/widgets/custom_fields.dart';
import '../../../../core/common/widgets/custom_input_field.dart';
import '../../../../core/common/widgets/custom_toggle_button.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/functions/functions.dart';
import '../../../../core/values/color_manager.dart';
import '../../../../core/values/font_size_manager.dart';
import '../../../../core/values/string_manager.dart';
import '../../../../di.dart';
import '../blocs/homepage_bloc/homepage_bloc.dart';
import '../widgets/custom_chart.dart';
import '../widgets/side_tabs.dart';

part '../widgets/homepage_widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Timer? _timer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (d) {
      setState(() {});
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    bool largeScreen = MediaQuery.of(context).size.width >= 1000;

    return BlocProvider<HomepageBloc>(
      create: (context) =>
          getIt()..add(const HomepageConfigureMqttClientEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
              key: _scaffoldKey,
              backgroundColor: themeData.scaffoldBackgroundColor,
              drawer: SideTabs(
                smallscreen: true,
                homepageBloc: context.read<HomepageBloc>(),
              ),
              body: _buildBody(largeScreen, themeData, context));
        },
      ),
    );
  }

  Widget _buildBody(
      bool largeScreen, ThemeData themeData, BuildContext context) {
    return SafeArea(
      child: largeScreen
          ? _buildLargeScreenDisplay(themeData, context)
          : Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.r, 30.r, 24.r, 20.r),
              child: _buildCommonTemperatureSummary(
                  context, themeData, !largeScreen),
            ),
    );
  }

  Widget _buildLargeScreenDisplay(ThemeData themeData, BuildContext context) {
    return Row(
      children: [
        SideTabs(homepageBloc: context.read<HomepageBloc>()),
        Expanded(
          child: PageView(
            controller: context.read<HomepageBloc>().pageController2,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) =>
                context.read<HomepageBloc>().add(HomepageUpdateTabIndex(value)),
            allowImplicitScrolling: true,
            children: [
              _buildLargeScreenBodyDisplay(context, themeData),
              PlotPage(homepageBloc: context.read<HomepageBloc>()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenBodyDisplay(
      BuildContext context, ThemeData themeData) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.r, 30.r, 24.r, 20.r),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildCommonTemperatureSummary(context, themeData, false),
          ),
          VerticalDivider(
            color: ColorManager.blue.withOpacity(0.3),
            width: 80.r,
          ),
          Expanded(
            flex: 4,
            child: _buildLargeScreenTemperaturePlot(themeData),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonTemperatureSummary(
      BuildContext context, ThemeData themeData, bool smallscreen) {
    return Column(
      children: [
        Row(
          children: [
            if (smallscreen)
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
            Text(StringManager.welcomeBack,
                style: themeData.textTheme.bodyLarge),
          ],
        ),
        Gap(smallscreen ? 36.r : 50.r),
        _buildTemperatureUnitToggle(themeData),
        Gap(smallscreen ? 20.r : 40.r),
        Expanded(
          child: PageView(
            controller: context.read<HomepageBloc>().pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) => context
                .read<HomepageBloc>()
                .add(HomepageUpdateHomepageIndex(value)),
            allowImplicitScrolling: true,
            children: [
              _buildCommonTemperatureScrollableDataDisplay(
                  smallscreen, themeData),
              _updateInterval(smallscreen, themeData),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommonTemperatureScrollableDataDisplay(
      bool smallscreen, ThemeData themeData) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(
          top: smallscreen ? 20.r : 30.r, bottom: 40.r),
      child: Column(
        children: [
          _buildTempBarDisplay(themeData),
          BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
            return Text(
              "${StringManager.lastUpdate}: ${state.sensorReadings.isEmpty ? 'NIL' : timeAgo(state.sensorReadings[state.selectedIndex].last.time)}",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(color: ColorManager.mediumGrey),
            );
          }),
          Gap(smallscreen ? 30.r : 60.r),
          _buildTemperatureAndHumidityReadings(),
          if (smallscreen) _buildSmallScreenGraph(themeData),
        ],
      ),
    );
  }

  Widget _updateInterval(bool smallscreen, ThemeData themeData) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(
          top: smallscreen ? 10.r : 15.r, bottom: 40.r),
      child:
          BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
        HomepageBloc bloc = context.read<HomepageBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${StringManager.updateReportingInterval} for ${state.sensors.isEmpty ? '--' : state.sensors[state.selectedIndex].toUpperCase()}',
              style: themeData.textTheme.bodyMedium,
            ),
            Gap(20.r),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: CustomInputField(
                      textController: bloc.reportingIntervalController,
                      hintText: StringManager.enterValue,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (p0) {
                        bloc.add(HomepageUpdateReportingInterval(
                            p0.isEmpty ? 0 : int.parse(p0)));
                      },
                      maxLength: 5,
                    )),
                Gap(15.w),
                Expanded(
                    child: CustomDropDown(
                  items: AppConstants.durationType
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: themeData.textTheme.bodyMedium,
                          )))
                      .toList(),
                  value: state.intervalLabel,
                  onChanged: (val) {
                    if (val == null) return;
                    bloc.add(HomepageUpdateIntervalLabel(val));
                  },
                )),
              ],
            ),
            Gap(30.r),
            CustomButton(
              text: StringManager.update,
              onTap: state.sensors.isEmpty || state.reportingInterval <= 0
                  ? null
                  : () {
                      bloc.add(const HomepageUpdateReportingIntervalInArduino(
                          UpdateType.reporting));
                    },
            ),
            Gap(30.r),
            Text(
              '${StringManager.updateSamplingInterval} for ${state.sensors.isEmpty ? '--' : state.sensors[state.selectedIndex].toUpperCase()}',
              style: themeData.textTheme.bodyMedium,
            ),
            Gap(20.r),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: CustomInputField(
                      textController: bloc.samplingIntervalController,
                      hintText: StringManager.enterValue,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (p0) {
                        bloc.add(HomepageUpdateSamplingInterval(
                            p0.isEmpty ? 0 : int.parse(p0)));
                      },
                      maxLength: 5,
                    )),
                Gap(15.w),
                Expanded(
                    child: CustomDropDown(
                  items: AppConstants.durationType
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: themeData.textTheme.bodyMedium,
                          )))
                      .toList(),
                  value: state.samplingIntervalLabel,
                  onChanged: (val) {
                    if (val == null) return;
                    bloc.add(HomepageUpdateSamplingIntervalLabel(val));
                  },
                )),
              ],
            ),
            Gap(30.r),
            CustomButton(
              text: StringManager.update,
              onTap: state.sensors.isEmpty || state.samplingInterval <= 0
                  ? null
                  : () {
                      bloc.add(const HomepageUpdateReportingIntervalInArduino(
                          UpdateType.sampling));
                    },
            ),
            Gap(30.r),
            Text(
              '${StringManager.updateMaxThreshold} for ${state.sensors.isEmpty ? '--' : state.sensors[state.selectedIndex].toUpperCase()}',
              style: themeData.textTheme.bodyMedium,
            ),
            Gap(20.r),
            CustomInputField(
              textController: bloc.maxThresholdController,
              hintText: StringManager.enterValue,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (p0) {
                bloc.add(HomepageUpdateMaxThreshold(
                    p0.isEmpty ? 0 : double.parse(p0)));
              },
              maxLength: 2,
            ),
            Gap(30.r),
            CustomButton(
              text: StringManager.update,
              onTap: state.sensors.isEmpty ||
                      bloc.maxThresholdController.text.isEmpty
                  ? null
                  : () {
                      bloc.add(const HomepageUpdateReportingIntervalInArduino(
                          UpdateType.max));
                    },
            ),
            Gap(30.r),
            Text(
              '${StringManager.updateMinThreshold} for ${state.sensors.isEmpty ? '--' : state.sensors[state.selectedIndex].toUpperCase()}',
              style: themeData.textTheme.bodyMedium,
            ),
            Gap(20.r),
            CustomInputField(
              textController: bloc.minThresholdController,
              hintText: StringManager.enterValue,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (p0) {
                bloc.add(HomepageUpdateMinThreshold(
                    p0.isEmpty ? 0 : double.parse(p0)));
              },
              maxLength: 2,
            ),
            Gap(30.r),
            CustomButton(
              text: StringManager.update,
              onTap: state.sensors.isEmpty ||
                      bloc.minThresholdController.text.isEmpty
                  ? null
                  : () {
                      bloc.add(const HomepageUpdateReportingIntervalInArduino(
                          UpdateType.min));
                    },
            ),
          ],
        );
      }),
    );
  }
}
