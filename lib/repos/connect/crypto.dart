import 'dart:convert';
import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';
import './bidInt.dart';
import 'package:diffie_hellman/diffie_hellman.dart';

class CryptoCipher {
  late final RSAPrivateKey __my_private_RSA_key;
  late final RSAPublicKey __my_public_RSA_key;
  late RSAPublicKey __client_public_RSA_key;
  final Uint8List __staticKey;
  Uint8List __iv;
  late Uint8List __key;
  late DhParameter __parameters;
  late DhPublicKey __dhPublicKey;
  late DhPkcs3Engine __dhEngine;

  CryptoCipher({
    required Uint8List staticKey,
    required Uint8List iv,
  }): __staticKey = staticKey,
      __iv = iv,
      __key = staticKey
    {
      AsymmetricKeyPair keyPair = generateRSAKeyPair();
      this.__my_private_RSA_key = keyPair.privateKey as RSAPrivateKey;
      this.__my_public_RSA_key = keyPair.publicKey as RSAPublicKey;
      this.__client_public_RSA_key = this.__my_public_RSA_key;
    }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64),
          _getSecureRandom()));

    final pair = keyGen.generateKeyPair();
    final publicKey = pair.publicKey as RSAPublicKey;
    final privateKey = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(publicKey, privateKey);
  }

  SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Uint8List(32); // 256 бит
    secureRandom.seed(KeyParameter(seedSource));
    return secureRandom;
  }

  Uint8List rsaEncrypt(Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(this.__client_public_RSA_key));

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List rsaDecrypt(Uint8List dataToDecrypt) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(this.__my_private_RSA_key));

    return _processInBlocks(decryptor, dataToDecrypt);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize;
    List<int> output = [];

    for (var i = 0; i < numBlocks; i++) {
      final offset = i * engine.inputBlockSize;
      final chunk = input.sublist(offset, offset + engine.inputBlockSize);
      final processed = engine.process(chunk);
      output.addAll(processed);
    }
    if (numBlocks == 0){
      output = engine.process(input);
    }
    else if (input.length % engine.inputBlockSize != 0){
      final offset = numBlocks*engine.inputBlockSize;
      final chunk = input.sublist(offset, input.length);
      final processed = engine.process(chunk);
      output.addAll(processed);
    }

    return Uint8List.fromList(output);
  }

  Uint8List aesEncrypt(Uint8List data) {
    final paddedData = _pad(data);
    final cipher = CBCBlockCipher(AESEngine())
      ..init(true, ParametersWithIV(KeyParameter(this.__key), this.__iv));

    return _processBlocks(cipher, paddedData);
  }

  Uint8List aesDecrypt(Uint8List encryptedData) {
    final cipher = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV(KeyParameter(this.__key), this.__iv));

    final decryptedData = _processBlocks(cipher, encryptedData);
    return _unpad(decryptedData);
  }

  Uint8List _processBlocks(BlockCipher cipher, Uint8List input) {
    final output = Uint8List(input.length);
    for (var offset = 0; offset < input.length; offset += cipher.blockSize) {
      cipher.processBlock(input, offset, output, offset);
    }
    return output;
  }

  Uint8List _pad(Uint8List data) {
    var paddedData = data.toList();
    var x = data.last != 0 ? 0 : 255;
    if (paddedData. length % 16 != 0)
      while (paddedData.length % 16 != 0){
        paddedData.add(x);
      }
    else if (paddedData.last == 0 || paddedData.last == 255){
      for (var i = 0; i < 16; i++) {
        paddedData.add(x);
      }
    }
    return Uint8List.fromList(paddedData);
  }

  Uint8List _unpad(Uint8List data) {
    var paddedData = data.toList();
    var x = data.last == 0 ? 0 : 255;
    while (paddedData.last == x){
      paddedData.removeLast();
    }
    return Uint8List.fromList(paddedData);
  }

  Uint8List rsaPaesEncrypt(Uint8List data) => rsaEncrypt(aesEncrypt(data));
  Uint8List rsaPaesDecrypt(Uint8List data) => aesDecrypt(rsaDecrypt(data));

  Uint8List encrypt(Uint8List data) => aesEncrypt(data);
  Uint8List decrypt(Uint8List data) => aesDecrypt(data);

  Uint8List publicRsaKeyToBytes(RSAPublicKey publicKey) {
    final modulusBytes = bigIntToBytes(publicKey.modulus!);
    final exponentBytes = bigIntToBytes(publicKey.exponent!);

    final modulusLength = modulusBytes.length;
    final exponentLength = exponentBytes.length;

    final buffer = ByteData(modulusLength + exponentLength + 8);
    buffer.setUint32(0, modulusLength, Endian.big);
    buffer.setUint32(4, exponentLength, Endian.big);
    buffer.buffer.asUint8List().setRange(8, 8 + modulusLength, modulusBytes);
    buffer.buffer.asUint8List().setRange(8 + modulusLength, 8 + modulusLength + exponentLength, exponentBytes);

    return buffer.buffer.asUint8List();
  }

  RSAPublicKey pythonStringToPublicRsaKey(String pem){
    List<int> bytes = base64.decode(pem 
        .replaceAll('-----BEGIN PUBLIC KEY-----', '') 
        .replaceAll('-----END PUBLIC KEY-----', '') 
        .replaceAll('\n', '') 
        .replaceAll('\r', ''));

    return pythonBytesToPublicRsaKey(Uint8List.fromList(bytes));
  }

  RSAPublicKey pythonBytesToPublicRsaKey(Uint8List bytes) {
    final asn1Parser = ASN1Parser(bytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    final publicKeyBitString = topLevelSeq.elements[1] as ASN1BitString;

    final publicKeyAsn1Parser = ASN1Parser(publicKeyBitString.contentBytes());
    final publicKeySeq = publicKeyAsn1Parser.nextObject() as ASN1Sequence;
    final modulus = publicKeySeq.elements[0] as ASN1Integer;
    final exponent = publicKeySeq.elements[1] as ASN1Integer;

    return RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
  }

  DhParameter PEM2Parameter(String pem){
    return DhParameter.fromPem(pem);
  }

  DhParameter pythonBytesToDartParameters(Uint8List p_bytes, Uint8List g_bytes){
    final p = bytesToBigInt(p_bytes);
    final g = bytesToBigInt(g_bytes);

    return DhParameter(p: p, g: g);
  }

  DhPublicKey PEM_bytesToPublicKey(String pem){
    return DhPublicKey.fromPem(pem);
  }

  DhPublicKey bytesToPublicKey(Uint8List bytes, {DhParameter? parameter = null}) {
    var value = bytesToBigInt(bytes);
    var key = DhPublicKey(value, parameter: parameter ?? this.__parameters);
    return key;
  }

  Uint8List publicKeyToBytes(DhPublicKey publicKey) {
    return bigIntToBytes(publicKey.value);
  }

  RSAPublicKey get my_public_RSA_key => __my_public_RSA_key;
  DhPublicKey get dh_public_key => __dhPublicKey;
  set client_public_RSA_key(RSAPublicKey key){
    __client_public_RSA_key = key;
  }

  set parameters(String pem){
    this.__parameters = DhParameter.fromPem(pem);

    var dhEngine = DhPkcs3Engine.fromParameter(this.__parameters);
    var keyPair = dhEngine.generateKeyPair();

    this.__dhPublicKey = keyPair.publicKey;
    this.__dhEngine = dhEngine;

  }

  get key => __key;

  Uint8List getKey(Uint8List staticKey, Uint8List dKey) {
    int halfLength = (dKey.length / 2).floor();
    Uint8List key = Uint8List.fromList(
      dKey.sublist(0, halfLength) + staticKey + dKey.sublist(halfLength, dKey.length)
    );

    var sha256 = SHA256Digest();
    var keyHash = sha256.process(key);

    return keyHash;
  }


  set server_dh_public_key(DhPublicKey key){
    var secret = __dhEngine.computeSecretKey(key.value);
    var byte_secret = bigIntToBytes(secret);
    this.__key = getKey(this.__staticKey, byte_secret);
    this.__iv = xorUint8Lists(
      bigIntToBytes(__dhPublicKey.value).sublist(0, 16),
      bigIntToBytes(key.value).sublist(0, 16)
    );
  }

  get iv => __iv;

}
