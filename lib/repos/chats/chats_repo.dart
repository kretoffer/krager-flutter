import 'package:krager/repos/chats/models/chat_model.dart';
import 'package:dio/dio.dart';

class ChatsReposirory{
  Future<List<Chat>> getChatsList() async{
    //TODO url to real server and real chat return
    const url = 'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,BNB,LOX,POD,AID,SOL,XUI&tsyms=USD,EUR,RUB,BYN';
    final response = await Dio().get(url);

    final data = response.data as Map<String, dynamic>;
    final dataList = data.entries.map(
      (e) => Chat(name: "NoName",
      lastMessage: "lastMessage", 
      iconURL: "https://st.depositphotos.com/1898481/3858/i/450/depositphotos_38585251-stock-photo-unnamed.jpg",
      id: "kretoffi",
      type: "user"
      )
    ).toList();

    return dataList;
  }
}