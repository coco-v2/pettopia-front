import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pettopia_front/Menu/AppBar.dart';
import 'package:pettopia_front/enum/appBarList.dart';
import 'package:pettopia_front/Menu/CustomBottomNavigatorBar.dart';
import 'package:pettopia_front/hospital/page/shortRecords.dart';
import 'package:pettopia_front/hospital/page/shortWrite.dart';
import 'package:pettopia_front/hospital/page/viewRecords.dart';
import 'package:pettopia_front/hospital/widget/petSeletBox.dart';
import 'package:pettopia_front/hospital/widget/shortRecordBar.dart';
import 'package:pettopia_front/server/DB/ShotRecords.dart';

class ShortWriteValue extends StatefulWidget {
  final DateTime selectedDay;
  final List<Map<String, dynamic>> petList;
  const ShortWriteValue(
      {Key? key, required this.selectedDay, required this.petList})
      : super(key: key);

  @override
  _ShortWriteValueState createState() => _ShortWriteValueState();
}

class _ShortWriteValueState extends State<ShortWriteValue>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late List<Map<String, dynamic>> _hospitalAppBar;
  AppBarList _appBarList = AppBarList();
  @override
  void initState() {
    super.initState();

    _hospitalAppBar = _appBarList.getHospitalAppBar();
  }

  late String _petName = widget.petList.first['dogNm'];
  late String _type = "";
  late int _count = 0;
  late int _age = 0;
  late int _pk = widget.petList.first['petPk'];
  final shotRecordsServer = ShotRecords();
  String _errorText = "";

  void _petNameHandler(String value, int valuePk) {
    _petName = value;
    _pk = valuePk;
  }

  void _typeHandler(String value) {
    _type = value;
  }

  void _countHandler(String value) {
    _count = int.parse(value);
  }

  void _ageHandler(String value) {
    _age = int.parse(value);
  }

  void _savedButton() {
    if (_type == "") {
      setState(() {
        _errorText = "필수 입력 사항을 모두 입력해주세요";
      });
    } else {
      shotRecordsServer.makeShotRecords(
          _pk, _type, _count, _age, widget.selectedDay, context);
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.7272727273, 783.2727272727),
      child: MaterialApp(
        title: "shortRecords",
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromRGBO(237, 237, 233, 1.0),
          body: Column(children: <Widget>[
            CustomAppBar(
                page: 1,
                barList: _hospitalAppBar,
                buttonHandler: _appBarList.hospitalAppBarHandler),
            Container(
                height: 485.h,
                width: 500.w,
                margin:
                    EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 20.0.w),
                decoration: BoxDecoration(
                  color: Color(0xFFE3D5CA),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                    margin: EdgeInsets.only(
                        bottom: 30.h, right: 30.w, top: 50.h, left: 30.w),
                    height: 300.h,
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        _typeContainer("날짜", 5),
                        Text(
                          DateFormat("yyyy년 MM월 dd일")
                              .format(widget.selectedDay),
                          style: TextStyle(fontSize: 17.sp),
                        ),
                      ]),
                      Container(
                        height: 120.h,
                        child: Stack(children: [
                          Positioned(
                            top: 50.h,
                            child: Container(
                              width: 300.w,
                              height: 70.h,
                              child: _textFieldContainer("종류", "접종 종류를 알려주세요 ",
                                  20, 10, _typeHandler, false, 0),
                            ),
                          ),
                          //petSelctBox
                          Positioned(
                              child: Container(
                                  width: 300.w,
                                  height: 100.h,
                                  // color: Colors.blue,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 5.w,
                                            top: 20.h,
                                            bottom: 45.w),
                                        width: 80.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD5BDAF),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "이름",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      PetSelectBox(
                                          onRegionSelected: _petNameHandler,
                                          petName: widget.petList)
                                    ],
                                  ))),
                        ]),
                      ),
                      _textFieldContainer("차시", "몇차 접종인지 알려주세요 ", 14, 10,
                          _countHandler, true, 5),
                      _textFieldContainer(
                          "나이", "몇 개월 차인지 알려주세요", 13, 10, _ageHandler, true, 5),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        _errorText,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      _createButton(_savedButton),
                    ]))),
          ]),
          bottomNavigationBar: CustomBottomNavigatorBar(page: 1),
        ),
      ),
    );
  }
}

Widget _typeContainer(String containerName, int leftMargin) {
  return Container(
    margin: EdgeInsets.only(right: 20.w, top: 20.h, left: leftMargin.w),
    width: 80.w,
    height: 40.h,
    decoration: BoxDecoration(
      color: Color(0xFFD5BDAF),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Text(
        containerName,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
}

Widget _textFieldContainer(
    String containerName,
    String labelText,
    int horizontal,
    int vertical,
    Function contorller,
    bool isDigit,
    int leftMargin) {
  return Row(
    children: <Widget>[
      _typeContainer(containerName, leftMargin),
      Container(
          width: 170.w,
          child: TextField(
              onChanged: (text) {
                contorller(text);
              },
              keyboardType: isDigit ? TextInputType.number : null,
              decoration: InputDecoration(
                hintText: labelText,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: horizontal.w, vertical: vertical.h),
                hintStyle: TextStyle(
                  fontSize: 11.0.sp,
                  color: Color(0xFFAFA59B),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD5BDAF)),
                ),
              ))),
    ],
  );
}

Widget _createButton(Function controller) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    width: 150.w,
    height: 50.h,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 180, 178, 176),
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: ElevatedButton(
      onPressed: () {
        controller();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFAFA59B)),
      ),
      child: Center(
        child: Text(
          '등록',
          style: TextStyle(fontSize: 15.sp, color: Colors.black),
        ),
      ),
    ),
  );
}
