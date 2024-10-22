import 'package:flutter/widgets.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  double get aspectRatio => width / height;

  // Height scaling
  double heightScale(double inputHeight) {
    return inputHeight * (height / 812); // Reference: iPhone 11 Pro Max height
  }

  // Width scaling
  double widthScale(double inputWidth) {
    return inputWidth * (width / 375); // Reference: iPhone 11 Pro Max width
  }

  // Font scaling based on width
  double fontScale(double inputFontSize) {
    return inputFontSize * (width / 375);
  }

  // Radius scaling based on width
  double radiusScale(double inputRadius) {
    return inputRadius * (width / 375); // Use width as reference for radius
  }
}
