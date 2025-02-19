import 'package:krager/domains/entities/User.dart';

class UserRepository {
  Future<User> getUser(String chatID) async{
    switch (chatID) {
      case "kretoffi": 
        return User(userID: "kretoffi", type: "user", name: "artem", lastName: null, iconURL: "https://st.depositphotos.com/1898481/3858/i/450/depositphotos_38585251-stock-photo-unnamed.jpg");
      case "userIDDD": 
        return User(userID: "userIDDD", type: "user", name: "name", lastName: "lastMessage", iconURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Skull-Icon.svg/2048px-Skull-Icon.svg.png");
    }
    return User(userID: "XXXXXXXX", type: "ERROR", name: "EROROOROEROROE", lastName: "lastMessageOfError", iconURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Skull-Icon.svg/2048px-Skull-Icon.svg.png");
  }
}