// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

import 'package:ednet_figma_exporter/studies/crane/backlayer.dart';
import 'package:ednet_figma_exporter/studies/crane/header_form.dart';

class SleepForm extends BackLayerItem {
  const SleepForm({super.key}) : super(index: 1);

  @override
  State<SleepForm> createState() => _SleepFormState();
}

class _SleepFormState extends State<SleepForm> with RestorationMixin {
  final travelerController = RestorableTextEditingController();
  final dateController = RestorableTextEditingController();
  final locationController = RestorableTextEditingController();

  @override
  String get restorationId => 'sleep_form';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(travelerController, 'diner_controller');
    registerForRestoration(dateController, 'date_controller');
    registerForRestoration(locationController, 'time_controller');
  }

  @override
  void dispose() {
    travelerController.dispose();
    dateController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = GalleryLocalizations.of(context)!;

    return HeaderForm(
      fields: <HeaderFormField>[
        HeaderFormField(
          index: 0,
          iconData: Icons.person,
          title: localizations.craneFormTravelers,
          textController: travelerController.value,
        ),
        HeaderFormField(
          index: 1,
          iconData: Icons.date_range,
          title: localizations.craneFormDates,
          textController: dateController.value,
        ),
        HeaderFormField(
          index: 2,
          iconData: Icons.hotel,
          title: localizations.craneFormLocation,
          textController: locationController.value,
        ),
      ],
    );
  }
}
