import 'package:flutter/material.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/user/widgets/user_card.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

/// Builds a [CustomScrollView] for the [users].
///
/// An optional list of [endSlivers] are built after the [users].
class UserList extends StatelessWidget {
  const UserList(
    this.users, {
    this.endSlivers = const <Widget>[],
    this.enableScroll = true,
  });

  final List<UserData> users;

  /// Slivers built at the end of the [CustomScrollView].
  final List<Widget> endSlivers;

  /// Whether the user list should be scrollable.
  final bool enableScroll;

  Widget _itemBuilder(BuildContext context, int index) {
    if (index.isEven) {
      return UserCard(users[index ~/ 2]);
    } else {
      return defaultVerticalSpacer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: enableScroll ? null : const NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverPadding(
          padding: DefaultEdgeInsets.all(),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              _itemBuilder,
              childCount: users.length * 2 - 1,
              addAutomaticKeepAlives: false,
            ),
          ),
        ),
        ...endSlivers,
      ],
    );
  }
}
