// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:watermeter/controller/classtable_controller.dart';

import 'package:watermeter/repository/preference.dart' as preference;

import 'package:watermeter/page/homepage/info_widget/classtable_card/classtable_card.dart';
import 'package:watermeter/page/homepage/dynamic_widget/electricity_card.dart';
import 'package:watermeter/page/homepage/dynamic_widget/library_card.dart';
import 'package:watermeter/page/homepage/dynamic_widget/school_card_info_card.dart';
import 'package:watermeter/page/homepage/dynamic_widget/sport_card.dart';
import 'package:watermeter/page/homepage/refresh.dart';

class PhoneMainPage extends StatelessWidget {
  const PhoneMainPage({super.key});

  final classCardHeight = 140.0;

  final List<Widget> children = const [
    SportCard(),
    ElectricityCard(),
    LibraryCard(),
    SchoolCardInfoCard(),
  ];

  String get _now {
    DateTime now = DateTime.now();
    if (now.hour >= 5 && now.hour < 11) {
      return "早上好 " + preference.getString(preference.Preference.name);
    } else if (now.hour >= 11 && now.hour < 17) {
      return "中午好 " + preference.getString(preference.Preference.name);
    } else {
      return "晚上好 " + preference.getString(preference.Preference.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            centerTitle: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.05,
                vertical: 16,
              ),
              title: GetBuilder<ClassTableController>(
                builder: (c) => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _now,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      c.isGet
                          ? c.isNotVacation
                              ? "第 ${c.currentWeek + 1} 周"
                              : "假期中"
                          : c.error != null
                              ? "加载错误"
                              : "正在加载",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: EasyRefresh(
          onRefresh: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("加载中..."),
            ));
            update();
          },
          header: PhoenixHeader(
            skyColor: Theme.of(context).colorScheme.primaryContainer,
            position: IndicatorPosition.locator,
            safeArea: true,
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              children: [
                const HeaderLocator(),
                Text(
                  "日程",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700),
                ).padding(
                  left: 20,
                  top: 10,
                  right: 0,
                  bottom: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.030,
                  ),
                  child: LayoutGrid(
                    columnSizes: [1.fr],
                    rowSizes: const [auto],
                    children: const [
                      ClassTableCard(),
                    ],
                  ),
                ),
                Text(
                  "动态信息",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700),
                ).padding(
                  left: 20,
                  top: 20,
                  right: 0,
                  bottom: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.040,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double squareSize =
                          constraints.maxWidth * 0.5; // 正方形的大小为父容器宽度的一半
                      return LayoutGrid(
                        columnSizes: [1.fr, 1.fr],
                        rowSizes: [squareSize.px, squareSize.px, auto, auto],
                        children: children.map((child) {
                          return AspectRatio(
                            aspectRatio: 1, // 设置宽高比为1，即正方形
                            child: Align(
                              alignment: Alignment.center,
                              child: child,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
