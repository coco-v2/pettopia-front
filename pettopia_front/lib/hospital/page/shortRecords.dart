import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettopia_front/Menu/CustomBottomNavigatorBar.dart';
import 'package:pettopia_front/hospital/page/shortWrite.dart';
import 'package:pettopia_front/hospital/page/viewRecords.dart';
import 'package:pettopia_front/hospital/widget/hospitalAppbar.dart';
import 'package:pettopia_front/hospital/widget/shortRecordBar.dart';


class ShortRecords extends StatefulWidget {
  const ShortRecords({Key? key}) : super(key: key);

  @override
  _ShortRecordshState createState() => _ShortRecordshState();
}

class _ShortRecordshState extends State<ShortRecords> {

  int _index=0;

  int _getIndex(int index){
    _index=index;
    return index;
  }
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.4, 683.4),
      child: MaterialApp(
        title: "shortRecords",
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: Scaffold(
          backgroundColor: Color.fromRGBO(237, 237, 233, 1.0),
          body:Column(
            children: <Widget>[
              HospitalAppBar(page: 1),
               Container(
                height: 485.h,
                
                margin:
                    EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 20.0.w),
                decoration: BoxDecoration(
                  color: Color(0xFFD5BDAF),
                  borderRadius: BorderRadius.circular(25),
                ),
            
       
          child: Column(
            children:<Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                height:40.h,
                // color:Colors.blue,
                child: ShortRecordBar(
                  indexNum: _index,
                  index: (index){
                    setState(() {
                      _index=_getIndex(index);
                    });
                  },
                ),
              ),
              Container(
                height:420.h,
                child:  buildWidget(_index)
              )
            ]
          )
      
        ),
              ]),
             
          bottomNavigationBar: CustomBottomNavigatorBar(page: 1),
        ),
      ),
    );
  }
}
Widget buildWidget(int index) {
  switch (index) {
    case 1:
      return ShortWrite();
    case 2:
      return ViewRecords();
    default:
      return Container(); // 기본적으로 빈 컨테이너를 반환하거나 다른 처리를 수행할 수 있습니다.
  }
}