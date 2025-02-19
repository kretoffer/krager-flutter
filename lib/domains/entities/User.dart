import 'package:krager/domains/entities/base.dart';

class User extends BaseEntitie{
  final String userID;
  final String type;
  final String name;
  final String? lastName;
  final String iconURL;

  User({required this.userID, required this.type, required this.name, required this.lastName, required this.iconURL});
}