import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const Background({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar == null
          ? null
          : AppBar(
              backgroundColor: Colors.transparent, // Set transparent color
              elevation: 0, // Remove shadow
              title: (appBar as AppBar).title,
              actions: (appBar as AppBar).actions,
            ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 88, 61, 65),
              Color.fromARGB(255, 33, 33, 33),
              Color.fromARGB(255, 33, 33, 33),
              Color.fromARGB(255, 42, 88, 156),
            ],
            stops: [
              0.0,
              0.32,
              0.65,
              1,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 35, left: 35, top: 40),
            child: child,
          ),
        ),
      ),
    );
  }
}
