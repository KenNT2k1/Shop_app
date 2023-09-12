import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthModel {
  final String? idToken;
  final String? email;
  final String? refreshToken;
  final String? expiresIn;
  final String? localId;
  final int? expiredAt;

  const AuthModel({
    this.idToken,
    this.email,
    this.refreshToken,
    this.expiresIn,
    this.localId,
    this.expiredAt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
      idToken: json['idToken'] as String?,
      email: json['email'] as String?,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as String?,
      localId: json['localId'] as String?,
      expiredAt: json['expiredAt'] ??
          DateTime.now()
              .add(Duration(
                  seconds: int.tryParse(json['expiresIn'] ?? '0') ?? 0))
              .millisecondsSinceEpoch);

  Map<String, dynamic> toJson() => {
        'idToken': idToken,
        'email': email,
        'refreshToken': refreshToken,
        'expiresIn': expiresIn,
        'localId': localId,
        'expiredAt': expiredAt,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AuthModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      idToken.hashCode ^
      email.hashCode ^
      refreshToken.hashCode ^
      expiresIn.hashCode ^
      expiredAt.hashCode ^
      localId.hashCode;
}
