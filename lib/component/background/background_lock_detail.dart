import 'package:flutter/material.dart';

class BackgroundLockDetail extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool? disabledTopPadding;
  final String? imageUrl; // String for image path or URL

  const BackgroundLockDetail({
    super.key,
    required this.child,
    this.appBar,
    this.disabledTopPadding,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar == null
          ? null
          : AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: (appBar as AppBar).title,
              actions: (appBar as AppBar).actions,
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox(
              width: double.infinity, // Full width
              height: double.infinity, // Full height
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? _buildImageWithGradient(imageUrl!)
                  : _buildGradientContainerWithoutImg(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                right: 35,
                left: 35,
                top: disabledTopPadding == true ? 10.0 : 40.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: child, // Ensures the child also fills the space
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithGradient(String imageUrl) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _getImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF212121).withOpacity(1.0),
                    Color(0xFF212121).withOpacity(0.25),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildGradientContainerWithImg(),
        ),
      ],
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(imageUrl);
    }
  }

  Widget _buildGradientContainerWithImg() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 33, 33, 33),
            Color.fromARGB(255, 42, 88, 156),
          ],
          stops: [0.30, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildGradientContainerWithoutImg() {
    return Container(
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
          stops: [0.0, 0.32, 0.65, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
