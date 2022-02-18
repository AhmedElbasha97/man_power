import 'package:flutter/material.dart';


import '../../../Global/theme.dart';

class ChattingCell extends StatelessWidget {
  const ChattingCell({Key? key, required this.sender, required this.messageText, required this.messageTime}) : super(key: key);
  final bool sender;
  final String messageText;
  final String messageTime;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            sender? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width*0.6),

                decoration: BoxDecoration(
                    color: sender ? offWhite: mainOrangeColorWithAlpha,
                    borderRadius: BorderRadius.only(
                      bottomRight:  Radius.circular(sender? 12 : 0),
                      bottomLeft:  Radius.circular(16),
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(sender ? 0 : 12),
                    )),
                child: Text(
                    messageText,
                    style: sender?TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        ):TextStyle(
                      fontSize: 14,
                      color: black,
                    )
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment:
              sender? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  messageTime,
                  style:TextStyle(
                    fontSize: 14,
                    color: Colors.black26,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
