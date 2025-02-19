import 'package:flutter/material.dart';
import 'package:krager/repos/chat/models/message_model.dart';

class MessageWidget extends StatelessWidget { 
  final Message message;

  const MessageWidget({super.key, required this.message});
  
  @override Widget build(BuildContext context) { 
    var messageBlock = Container( 
        padding: const EdgeInsets.all(10),
        //color: Colors.amber, 
        child: Text(message.text, style: Theme.of(context).textTheme.headlineSmall,),
    );
    var dateTime = DateTime.fromMicrosecondsSinceEpoch(message.time);
    var header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      //color: Colors.lightBlueAccent,
      child: Row(
        children: [Text(message.senderName, style: Theme.of(context).textTheme.bodyMedium)],
      ),
    );
    var footer = Container(
      //color: Colors.blueGrey,
      padding: const EdgeInsets.only(right: 10, bottom: 5),
      alignment: Alignment.centerRight,
      
      child: Text("${dateTime.hour.toString()}:${dateTime.minute.toString()}", style: Theme.of(context).textTheme.bodySmall,),
    );
    var width = MediaQuery.of(context).size.width * 0.7;
    var messageContent = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width > 600 ? 600 : width
      ),
      child: IntrinsicWidth(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            messageBlock,
            footer,
          ],
        )
      ),
    );
    return CustomPaint( 
      painter: MessagePainter(messagePainterType: MessagePainterType.single, sender: message.userType),
      child: messageContent, 
    ); 
  } 
} 

enum MessagePainterType {
  highest,
  average,
  lowest,
  single,
}

class MessagePainter extends CustomPainter { 
  
  final MessagePainterType messagePainterType;
  final UserType sender;
  MessagePainter({required this.messagePainterType, required this.sender});

  @override void paint(Canvas canvas, Size size) {

    double x1, x2, x3, x4;
    x1 = 10; x2 = 20; x3 = 20; x4 = 10;
    if (messagePainterType == MessagePainterType.highest || 
      messagePainterType == MessagePainterType.single){
        x1 = 20;
    }
    if (messagePainterType == MessagePainterType.lowest || 
      messagePainterType == MessagePainterType.single){
        x4 = 20;
    }

    var paint = Paint() ..style = PaintingStyle.fill;
    paint.color = sender == UserType.currentUser ? const Color.fromARGB(255, 107, 187, 252) : Colors.white;
    var path = Path()
    ..moveTo(x1, 0) ..lineTo(size.width - x2, 0) ..quadraticBezierTo(size.width, 0, size.width, x2) 
    ..lineTo(size.width, size.height - x3) 
    ..quadraticBezierTo(size.width, size.height, size.width - x3, size.height) 
    ..lineTo(x4, size.height);

    if (messagePainterType == MessagePainterType.lowest || 
      messagePainterType == MessagePainterType.single){
        path ..lineTo(0, size.height + 5) ..lineTo(5, size.height);
    }

    path ..moveTo(x4, size.height) ..quadraticBezierTo(0, size.height, 0, size.height-x4)
    ..lineTo(0, size.height - 10) ..lineTo(0, x1) ..quadraticBezierTo(0, 0, x1, 0) ..close(); 

    if (sender == UserType.currentUser){

      final matrix4 = Matrix4.identity()
      ..scale(-1.0, 1.0, 1.0)
      ..translate(-size.width, 0.0);

      path = path.transform(matrix4.storage);
    }

    canvas.drawPath(path, paint); 
  } 
  
  @override bool shouldRepaint(CustomPainter oldDelegate) => false; 
}
