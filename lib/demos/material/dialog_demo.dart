// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:ednet_figma_exporter/data/gallery_options.dart';
import 'package:ednet_figma_exporter/demos/material/material_demo_types.dart';

// BEGIN dialogDemo

class DialogDemo extends StatefulWidget {
  const DialogDemo({super.key, required this.type});

  final DialogDemoType type;

  @override
  State<DialogDemo> createState() => _DialogDemoState();
}

class _DialogDemoState extends State<DialogDemo> with RestorationMixin {
  late RestorableRouteFuture<String> _alertDialogRoute;
  late RestorableRouteFuture<String> _alertDialogWithTitleRoute;
  late RestorableRouteFuture<String> _simpleDialogRoute;

  @override
  String get restorationId => 'dialog_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(
      _alertDialogRoute,
      'alert_demo_dialog_route',
    );
    registerForRestoration(
      _alertDialogWithTitleRoute,
      'alert_demo_with_title_dialog_route',
    );
    registerForRestoration(
      _simpleDialogRoute,
      'simple_dialog_route',
    );
  }

  // Displays the popped String value in a SnackBar.
  void _showInSnackBar(String value) {
    // The value passed to Navigator.pop() or null.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          GalleryLocalizations.of(context)!.dialogSelectedOption(value),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _alertDialogRoute = RestorableRouteFuture<String>(
      onPresent: (navigator, arguments) {
        return navigator.restorablePush(_alertDialogDemoRoute);
      },
      onComplete: _showInSnackBar,
    );
    _alertDialogWithTitleRoute = RestorableRouteFuture<String>(
      onPresent: (navigator, arguments) {
        return navigator.restorablePush(_alertDialogWithTitleDemoRoute);
      },
      onComplete: _showInSnackBar,
    );
    _simpleDialogRoute = RestorableRouteFuture<String>(
      onPresent: (navigator, arguments) {
        return navigator.restorablePush(_simpleDialogDemoRoute);
      },
      onComplete: _showInSnackBar,
    );
  }

  String _title(BuildContext context) {
    final localizations = GalleryLocalizations.of(context)!;
    switch (widget.type) {
      case DialogDemoType.alert:
        return localizations.demoAlertDialogTitle;
      case DialogDemoType.alertTitle:
        return localizations.demoAlertTitleDialogTitle;
      case DialogDemoType.simple:
        return localizations.demoSimpleDialogTitle;
      case DialogDemoType.fullscreen:
        return localizations.demoFullscreenDialogTitle;
    }
  }

  static Route<String> _alertDialogDemoRoute(
    BuildContext context,
    Object? arguments,
  ) {
    final theme = Theme.of(context);
    final dialogTextStyle = theme.textTheme.titleMedium!
        .copyWith(color: theme.textTheme.bodySmall!.color);

    return DialogRoute<String>(
      context: context,
      builder: (context) {
        final localizations = GalleryLocalizations.of(context)!;
        return ApplyTextOptions(
            child: AlertDialog(
          content: Text(
            localizations.dialogDiscardTitle,
            style: dialogTextStyle,
          ),
          actions: [
            _DialogButton(text: localizations.dialogCancel),
            _DialogButton(text: localizations.dialogDiscard),
          ],
        ));
      },
    );
  }

  static Route<String> _alertDialogWithTitleDemoRoute(
    BuildContext context,
    Object? arguments,
  ) {
    final theme = Theme.of(context);
    final dialogTextStyle = theme.textTheme.titleMedium!
        .copyWith(color: theme.textTheme.bodySmall!.color);

    return DialogRoute<String>(
      context: context,
      builder: (context) {
        final localizations = GalleryLocalizations.of(context)!;
        return ApplyTextOptions(
          child: AlertDialog(
            title: Text(localizations.dialogLocationTitle),
            content: Text(
              localizations.dialogLocationDescription,
              style: dialogTextStyle,
            ),
            actions: [
              _DialogButton(text: localizations.dialogDisagree),
              _DialogButton(text: localizations.dialogAgree),
            ],
          ),
        );
      },
    );
  }

  static Route<String> _simpleDialogDemoRoute(
    BuildContext context,
    Object? arguments,
  ) {
    final theme = Theme.of(context);

    return DialogRoute<String>(
      context: context,
      builder: (context) => ApplyTextOptions(
        child: SimpleDialog(
          title: Text(GalleryLocalizations.of(context)!.dialogSetBackup),
          children: [
            _DialogDemoItem(
              icon: Icons.account_circle,
              color: theme.colorScheme.primary,
              text: 'username@gmail.com',
            ),
            _DialogDemoItem(
              icon: Icons.account_circle,
              color: theme.colorScheme.secondary,
              text: 'user02@gmail.com',
            ),
            _DialogDemoItem(
              icon: Icons.add_circle,
              text: GalleryLocalizations.of(context)!.dialogAddAccount,
              color: theme.disabledColor,
            ),
          ],
        ),
      ),
    );
  }

  static Route<void> _fullscreenDialogRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return MaterialPageRoute<void>(
      builder: (context) => _FullScreenDialogDemo(),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      // Adding [ValueKey] to make sure that the widget gets rebuilt when
      // changing type.
      key: ValueKey(widget.type),
      restorationScopeId: 'navigator',
      onGenerateRoute: (settings) {
        return _NoAnimationMaterialPageRoute<void>(
          settings: settings,
          builder: (context) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(_title(context)),
            ),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  switch (widget.type) {
                    case DialogDemoType.alert:
                      _alertDialogRoute.present();
                      break;
                    case DialogDemoType.alertTitle:
                      _alertDialogWithTitleRoute.present();
                      break;
                    case DialogDemoType.simple:
                      _simpleDialogRoute.present();
                      break;
                    case DialogDemoType.fullscreen:
                      Navigator.restorablePush<void>(
                          context, _fullscreenDialogRoute);
                      break;
                  }
                },
                child: Text(GalleryLocalizations.of(context)!.dialogShow),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A MaterialPageRoute without any transition animations.
class _NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  _NoAnimationMaterialPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop(text);
      },
      child: Text(text),
    );
  }
}

class _DialogDemoItem extends StatelessWidget {
  const _DialogDemoItem({
    this.icon,
    this.color,
    required this.text,
  });

  final IconData? icon;
  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.of(context).pop(text);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          Flexible(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = GalleryLocalizations.of(context)!;

    // Remove the MediaQuery padding because the demo is rendered inside of a
    // different page that already accounts for this padding.
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ApplyTextOptions(
        child: Scaffold(
          appBar: AppBar(
            title: Text(localizations.dialogFullscreenTitle),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  localizations.dialogFullscreenSave,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: Text(
              localizations.dialogFullscreenDescription,
            ),
          ),
        ),
      ),
    );
  }
}

// END
