import 'package:flutter/material.dart';
import 'package:lemon/components/primary_app_button.dart';
import 'package:lemon/utilities/extensions.dart';

class QueueCard extends StatelessWidget {
  final String token;
  final Map userData;
  final int index;
  final GestureTapCallback onTap;
  final bool button;
  const QueueCard({
    super.key,
    required this.index,
    required this.token,
    required this.userData,
    this.button = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          style: ListTileStyle.list,
          leading: Text(
            token,
            style: context.text.headlineSmall!.copyWith(
              fontSize: 17,
              letterSpacing: 2,
            ),
          ),
          title: Text(userData['displayName']),
          trailing: Text("#${index + 1}"),
        ),
        if (button)
          PrimaryAppButton(
            label: "served".capitalized,
            onTap: onTap,
            buttonColor: Colors.green,
          ),
      ],
    );
  }
}
