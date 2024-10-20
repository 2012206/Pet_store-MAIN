
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

///extension of SizeBox

extension EmptySpace on num {
  SizedBox get height => SizedBox(height: toDouble().h);
  SizedBox get width => SizedBox(width: toDouble().w);
}
