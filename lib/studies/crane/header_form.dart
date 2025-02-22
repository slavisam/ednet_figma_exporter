// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:ednet_figma_exporter/layout/adaptive.dart';
import 'package:ednet_figma_exporter/studies/crane/colors.dart';

const textFieldHeight = 60.0;
const appPaddingLarge = 120.0;
const appPaddingSmall = 24.0;

class HeaderFormField {
  final int index;
  final IconData iconData;
  final String title;
  final TextEditingController textController;

  const HeaderFormField({
    required this.index,
    required this.iconData,
    required this.title,
    required this.textController,
  });
}

class HeaderForm extends StatelessWidget {
  final List<HeaderFormField> fields;

  const HeaderForm({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final isSmallDesktop = isDisplaySmallDesktop(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            isDesktop && !isSmallDesktop ? appPaddingLarge : appPaddingSmall,
      ),
      child: isDesktop
          ? LayoutBuilder(builder: (context, constraints) {
              var crossAxisCount = isSmallDesktop ? 2 : 4;
              if (fields.length < crossAxisCount) {
                crossAxisCount = fields.length;
              }
              final itemWidth = constraints.maxWidth / crossAxisCount;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: itemWidth / textFieldHeight,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final field in fields)
                    if ((field.index + 1) % crossAxisCount == 0)
                      _HeaderTextField(field: field)
                    else
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 16),
                        child: _HeaderTextField(field: field),
                      ),
                ],
              );
            })
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final field in fields)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _HeaderTextField(field: field),
                  )
              ],
            ),
    );
  }
}

class _HeaderTextField extends StatelessWidget {
  final HeaderFormField field;

  const _HeaderTextField({required this.field});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: field.textController,
      cursorColor: Theme.of(context).colorScheme.secondary,
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
      onTap: () {},
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
        fillColor: cranePurple700,
        filled: true,
        hintText: field.title,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(
          field.iconData,
          size: 24,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
