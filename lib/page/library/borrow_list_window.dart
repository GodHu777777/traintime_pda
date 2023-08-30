// Copyright 2023 BenderBlog Rodriguez and contributors.
// SPDX-License-Identifier: MPL-2.0

// Borrow list, shows the user's borrowlist.

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:watermeter/controller/library_controller.dart';
import 'package:watermeter/page/library/borrow_info_card.dart';
import 'package:watermeter/page/sliver_grid_deligate_with_fixed_height.dart';

class BorrowListWindow extends StatelessWidget {
  const BorrowListWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryController c = Get.put(LibraryController());
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            elevation: 0,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("仍在借"),
                      Text("${c.notDued} 本"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("已过期"),
                      Text("${c.dued} 本"),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedHeight(
              height: 256,
              maxCrossAxisExtent: 320,
            ),
            children: List<Widget>.generate(
              c.borrowList.length,
              (index) => BorrowInfoCard(toUse: c.borrowList[index]),
            ),
          ),
        ),
      ],
    );
  }
}
