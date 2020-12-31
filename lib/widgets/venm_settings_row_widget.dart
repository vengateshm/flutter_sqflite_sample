import 'package:flutter/material.dart';

Widget settingsRowWidget(String title, String description, Function onTap) =>
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12.0, color: Colors.black38),
                ),
              ],
            )),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
