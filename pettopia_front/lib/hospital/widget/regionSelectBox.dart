import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettopia_front/enum/region.dart';

class RegionSelectBox extends StatefulWidget {
  final void Function(String selectedRegion)? onRegionSelected; // 선택한 지역을 알리는 콜백

  const RegionSelectBox({Key? key, this.onRegionSelected}) : super(key: key);

  @override
  _RegionSelectBoxState createState() => _RegionSelectBoxState();
}

class _RegionSelectBoxState extends State<RegionSelectBox> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Region _region;
  late List<String> _regionList;
  late String _regionValue;

  @override
  void initState() {
    super.initState();
    _region = Region();
    _regionList = _region.getRegionList();
    _regionValue = _regionList.first;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: 120.w,
      child: Row(
        children: [
          Flexible(
            child: DropdownButtonFormField<String>(
              itemHeight: 50.h,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              value: _regionValue,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "구를 선택해주세요요";
                }
                return null;
              },
              onChanged: (String? value) {
                setState(() {
                  _regionValue = value!;
                });
                // 선택한 지역을 알리는 콜백 호출
                if (widget.onRegionSelected != null) {
                  widget.onRegionSelected!(_regionValue);
                }
              },
              items: _regionList.map<DropdownMenuItem<String>>((String eachValue) {
                return DropdownMenuItem<String>(
                  value: eachValue,
                  child: Container(
                    height: 50.h,
                    child: Text(eachValue, style: TextStyle(fontSize: 10.sp)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}