import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/custom_sliver_app_bar.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

/// Builds a [SliverAppBar] with an optional background.
///
/// When a [background] is provided, a [FlexibleSpaceBar] will be built behind
/// the [AppBar].
class HarpySliverAppBar extends StatelessWidget {
  const HarpySliverAppBar({
    this.title,
    this.actions,
    this.showIcon = false,
    this.floating = false,
    this.stretch = false,
    this.pinned = false,
    this.background,
  });

  final String title;
  final List<Widget> actions;
  final bool showIcon;
  final bool floating;
  final bool stretch;
  final bool pinned;
  final Widget background;

  Widget _buildTitle(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Text(
            title ?? '',
            style: theme.textTheme.headline6,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
        if (showIcon) ...<Widget>[
          const SizedBox(width: 4),
          const FlareIcon.harpyLogo(size: 24),
        ],
      ],
    );
  }

  Widget _buildFlexibleSpace(ThemeData theme) {
    return FlexibleSpaceBar(
      // padding to prevent the text to get below the back arrow
      titlePadding: const EdgeInsets.only(left: 54, right: 54, bottom: 16),
      centerTitle: true,
      title: _buildTitle(theme),
      background: background,
      stretchModes: const <StretchMode>[
        StretchMode.zoomBackground,
        StretchMode.fadeTitle,
      ],
    );
  }

  /// Builds a decoration for the app bar with a gradient matching the
  /// background.
  Decoration _buildDecoration(
    HarpyTheme harpyTheme,
    MediaQueryData mediaQuery,
    double minExtend,
  ) {
    if (harpyTheme.backgroundColors.length == 1) {
      return BoxDecoration(color: harpyTheme.backgroundColors.first);
    }

    // min extend / mediaQuery.size * count of background colors minus the
    // first one
    final double t = minExtend /
        mediaQuery.size.height *
        (harpyTheme.backgroundColors.length - 1);

    final Color color = Color.lerp(
      harpyTheme.backgroundColors[0],
      harpyTheme.backgroundColors[1],
      t,
    );

    return BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          harpyTheme.backgroundColors.first,
          color,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HarpyTheme harpyTheme = HarpyTheme.of(context);
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    // whether a flexible space widget should be built for the sliver app bar
    final bool hasFlexibleSpace = background != null;

    final double expandedHeight = min(200, mediaQuery.size.height * .25);

    return CustomSliverAppBar(
      decorationBuilder: (double minExtend, double maxExtend) =>
          _buildDecoration(harpyTheme, mediaQuery, minExtend),
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      floating: floating,
      stretch: stretch,
      pinned: pinned,
      title: hasFlexibleSpace ? null : _buildTitle(theme),
      actions: actions,
      flexibleSpace: hasFlexibleSpace ? _buildFlexibleSpace(theme) : null,
      expandedHeight: hasFlexibleSpace ? expandedHeight : null,
    );
  }
}
