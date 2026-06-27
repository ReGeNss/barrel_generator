import 'dart:typed_data';

extension Uint8ListSearch on Uint8List {
  int indexOfSublist(Uint8List sublist, [int start = 0]) {
    if (sublist.isEmpty) return start;
    if (sublist.length > length) return -1;

    for (int i = start; i <= length - sublist.length; i++) {
      bool found = true;
      for (int j = 0; j < sublist.length; j++) {
        if (this[i + j] != sublist[j]) {
          found = false;
          break;
        }
      }
      if (found) return i;
    }
    return -1;
  }

  bool containsSublist(Uint8List sublist) {
    return indexOfSublist(sublist) != -1;
  }
}