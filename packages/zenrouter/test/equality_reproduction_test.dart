import 'package:flutter_test/flutter_test.dart';
import 'package:zenrouter/src/path/base.dart';
import 'package:zenrouter/zenrouter.dart';

import 'path/indexed_test.dart'; // Import to use CoordinatorThirdTab

void main() {
  test('CoordinatorThirdTab equality check', () {
    final tab1 = CoordinatorThirdTab();
    final tab2 = CoordinatorThirdTab();

    print('tab1 props: ${tab1.props}');
    print('tab2 props: ${tab2.props}');
    print('tab1 == tab2: ${tab1 == tab2}');

    expect(tab1, equals(tab2));
    expect(tab1 == tab2, isTrue);

    final list = [tab1];
    expect(list.indexOf(tab2), 0);
  });
}
