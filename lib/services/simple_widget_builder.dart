import 'package:flutter/material.dart';

abstract class SimpleWidgetBuilder {
  List<DropdownMenuItem<String>> buildDropdown({@required List<String> list});
}

class SimpleWidgetBuilderImplementation extends SimpleWidgetBuilder {
  List<DropdownMenuItem<String>> buildDropdown({@required List<String> list}) {
    return list.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();
  }
}
