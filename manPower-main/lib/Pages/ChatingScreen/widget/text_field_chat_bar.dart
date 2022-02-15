import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manpower/Global/theme.dart';


class TextFieldChatBar extends StatelessWidget {
   TextFieldChatBar({Key? key, required this.sendMassage,  }) : super(key: key);
  final Function sendMassage;

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20),),
        boxShadow: const [
          BoxShadow(color: Colors.black38, spreadRadius: 1, blurRadius: 1),
        ],
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height*0.25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width*0.9,

                    decoration: BoxDecoration(
                      color: offWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey,width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: TextField(
                           controller: myController,
                            cursorColor: mainOrangeColor,
                            autocorrect: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration:  InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),


                                hintText: 'اكتب رسالتك هنا')
                        )),
                        SizedBox(width: 20,),
                        GestureDetector(
                            onTap: (){sendMassage(myController.text);myController.clear();FocusScope.of(context).unfocus();},
                            child: SvgPicture.asset("assets/icon/send_icon.svg",width: 20,height: 17,color:mainOrangeColor),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
