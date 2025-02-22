import 'dart:typed_data';

Uint8List bigIntToBytes(BigInt number) {
  final hexString = number.toRadixString(16);
  final paddedHexString = hexString.length.isOdd ? '0$hexString' : hexString;
  return Uint8List.fromList(List<int>.generate(
    paddedHexString.length ~/ 2,
    (i) => int.parse(paddedHexString.substring(i * 2, i * 2 + 2), radix: 16),
  ));
}

BigInt bytesToBigInt(Uint8List bytes) {
  return BigInt.parse(bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join(), radix: 16);
}

Uint8List xorUint8Lists(Uint8List list1, Uint8List list2) {
  if (list1.length > list2.length) {
    var t = list1;
    list1 = list2;
    list2 = t;
  }

  Uint8List result = Uint8List(list1.length);
  for (int i = 0; i < list1.length; i++) {
    result[i] = list1[i] ^ list2[i];
  }

  return result;
}
