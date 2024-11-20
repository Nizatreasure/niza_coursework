import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/common/widgets/custom_circle_painter.dart';
import '../../../../core/common/widgets/custom_fields.dart';
import '../../../../core/common/widgets/custom_toggle_button.dart';
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

    return BlocProvider<HomepageBloc>(
      create: (context) =>
          getIt()..add(const HomepageConfigureMqttClientEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
              key: _scaffoldKey,
              backgroundColor: themeData.scaffoldBackgroundColor,
              drawer: AppDrawer(
                homepageBloc: context.read<HomepageBloc>(),
              ),
              body: _buildBody(themeData, context));
        },
      ),
    );
  }

  Widget _buildBody(ThemeData themeData, BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.r, 30.r, 24.r, 20.r),
        child: _buildTemperatureSummary(context, themeData),
      ),
    );
  }

  Widget _buildTemperatureSummary(BuildContext context, ThemeData themeData) {
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
            Text(StringManager.welcomeBack,
                style: themeData.textTheme.bodyLarge),
          ],
        ),
        Gap(36.r),
        _buildTemperatureUnitToggle(themeData),
        Expanded(
          child: _buildTemperatureScrollableDataDisplay(themeData),
        ),
      ],
    );
  }

  Widget _buildTemperatureScrollableDataDisplay(ThemeData themeData) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(top: 20.r, bottom: 40.r),
      child: Column(
        children: [
          _buildTempBarDisplay(themeData),
          BlocBuilder<HomepageBloc, HomepageState>(builder: (context, state) {
            return Text(
              "${StringManager.lastUpdate}: ${state.temperatureData.isEmpty ? 'NIL' : timeAgo(state.temperatureData.last.other)}",
              style: themeData.textTheme.bodyMedium!
                  .copyWith(color: ColorManager.mediumGrey),
            );
          }),
          Gap(30.r),
          _buildTemperatureAndHumidityReadings(),
          _buildGraph(themeData),
        ],
      ),
    );
  }
}
