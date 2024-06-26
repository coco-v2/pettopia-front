import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CreatePetParentValue extends StatefulWidget {
  final Function(String,String) petParentValueHandle;
  final String parentName;
  const CreatePetParentValue({
    Key? key,
    required this.petParentValueHandle,
    required this.parentName,
            
  }) : super(
          key: key,

        );

  @override
  _CreatePetParentValueState createState() => _CreatePetParentValueState();
}

class _CreatePetParentValueState extends State<CreatePetParentValue>  with AutomaticKeepAliveClientMixin {
    @override
  bool get wantKeepAlive => true;
 late String _parentName=widget.parentName;
 late String _parentPhoneNum="";
 late String _parentNameLabelText = widget.parentName != ""? widget.parentName:"보호자의 이름을 입력해주세요";
 late bool _isPet = widget.parentName != ""? true : false;
 void parentNameChange(String value){
  _parentName=value;
  widget.petParentValueHandle(_parentName, _parentPhoneNum);
 }
 void parentPhoneNumChange(String value){
  _parentPhoneNum=value;
   widget.petParentValueHandle(_parentName, _parentPhoneNum);
 }



 @override

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
     Center(
      child: Text("보호자 정보",
       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp ),)
     ),
     _textFieldContainer("이름*", _parentNameLabelText,parentNameChange,_isPet),

     _textFieldContainer("연락처*","010-****-****",parentPhoneNumChange,false)
    ]);
  }
  Widget _typeContainer(String name) {
  return Container(
      width: 80.w,
      height: 30.h,
       margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: Color(0xFFD5BDAF),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
          child: Text(
        name,
      )));
}


Widget _textFieldContainer(String containerName, String labelText,Function contorller, bool isPet){
  return   Container(
                  margin: EdgeInsets.only(bottom: 10.h, left: 15.w),
                  width: 380.w,
                  height: 30.h,
                  child: Row(
                    children: <Widget>[
                      _typeContainer(containerName),
                       Container(
                          width: 220.w,
                          child: TextField(
                              onChanged: (text) {
                                contorller(text);
                                print(text);
                                
                              },
                              decoration: InputDecoration(
                                hintText: labelText,

                               
                                hintStyle: TextStyle(fontSize: 11.0.sp, color: isPet == true ? Colors.black: Color(0xFFAFA59B),),
                                   border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFD5BDAF)),
    ),
                              ))),
                    ],
                  ));

}
}

