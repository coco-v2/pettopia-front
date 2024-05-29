import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 가져오기
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettopia_front/main.dart';
import 'package:pettopia_front/server/DB/Pet.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pettopia_front/Menu/CustomBottomNavigatorBar.dart';
import 'package:pettopia_front/server/DB/Users.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userServer = Users();
  late WebViewController _webViewController= WebViewController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late String _serverUrl="";
  Pet _petServer = Pet();

 @override
void initState() {
  super.initState();
  // _initializeWebview();
}

void _kakaoWebViewSetting() async {
  await _getServerUrl();
  String url = _serverUrl + "oauth2/authorization/kakao";
    // String url = 'http://10.0.2.2/' + "oauth2/authorization/kakao";
  print(url);
  _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(url))
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (NavigationRequest request) {
        print("Navigating to: ${request.url}");
        return NavigationDecision.navigate;
      },
      onPageFinished: (String url) {
        _webViewController
            .runJavaScriptReturningResult("document.body.outerHTML")
            .then((html) async {
          print("Page finished loading. URL: $url");
          if (url.contains("code=")) {
            print("OAuth code found in URL:");
            print(html);

            print(html.runtimeType);
            String strHtml = html as String;
           split(strHtml);
            // return NavigationDecision.prevent;

            // MyApp 또는 원하는 페이지로 이동
           
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()), // 여기에 원하는 페이지를 넣으세요
            );
          }
        }).catchError((error) {
          print("Error getting HTML: $error");
        });
      },
    ));
}

  Future<void> _getServerUrl() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e"); // 오류 메시지 출력
  }
  _serverUrl = dotenv.env['DB_SERVER_URI'] ?? 'YOUR_KAKAO_APP_KEY';
  print(_serverUrl);
}

  Future<void> _getUserPet() async{
    List<Map<String,dynamic>> petList = await _petServer.getPetList();
    List<Map<String,dynamic>> petValueList = [];
    for(Map<String,dynamic> value in petList){
      Map<String,dynamic>petInfo = await _petServer.getPetRegistration(value['petPk']);
      Map<String,dynamic>petAddInfo = await _petServer.getAddPetInfo(value['petPk']);
      petInfo['pk'] = value['petPk'];
      if(petAddInfo['petExtraInfo']['environment']!= null){
        petInfo['isAddInfo'] = true;
      }
      else{
        petInfo['isAddInfo'] = false;
      }
      petValueList.add(petInfo);
    }
    await _secureStorage.write(key: 'pet', value: jsonEncode(petValueList));

  }
  
  void split(String html)async {
    print("넘어온 html");
    print(html);
   RegExp jsonPattern = RegExp(r'\{.*\}', dotAll: true); // 중괄호 포함 부분 추출
  Iterable<Match> matches = jsonPattern.allMatches(html); // 모든 일치 항목 찾기

  if (matches.isNotEmpty) {
    String jsonString = matches.first.group(0)!; // 첫 번째 일치 항목 추출
    print("Extracted JSON: $jsonString");
    String jsonStr = jsonString.replaceAll(r'\', '');

    String accessToken="";
    String refreshToken="";
     final parts = jsonStr.split('"');
     for(int i=0; i< parts.length;i++){
      print(parts[i]);
     }
   for (int i = 0; i < parts.length; i++) {
      if (parts[i] == 'accessToken') {
        accessToken = parts[i + 2]; // 값이 따옴표 사이에 있기 때문
      } else if (parts[i] == 'refreshToken') {
        refreshToken = parts[i + 2];
      }
    }
    await saveToken(accessToken, refreshToken);


    print("Access Token: $accessToken");
    print("Refresh Token: $refreshToken");

     await _getUserPet();

  } else {
    print("No JSON object found.");
  }}

  Future<void> saveToken(String accessToken, String refreshToken) async{
    await _secureStorage.deleteAll();

    await _secureStorage.write(key: 'accessToken', value: accessToken);
    await _secureStorage.write(key: 'refreshToken', value:refreshToken);
  }

  void launchLogin() {
   
  
        Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewPage( controller: _webViewController),
      ),
    );
  }

 
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.42857142857144,683.4285714285714),
      builder: (_, __) {
        return MaterialApp(
             debugShowCheckedModeBanner: false ,
          title: "Login",
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color.fromRGBO(237, 237, 233, 1.0),
            body: Container(
              width: 400.w,
              height: 600.h,
              margin: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Color(0xFFE3D5CA),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 240.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/txtLogo.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text("로그인", style: TextStyle(fontSize: 20.sp)),
                  Divider(
                    height: 2.h,
                    thickness: 1,
                    color: Color(0xFFD5BDAF),
                  ),
                 Container(
    width: 185.w,
    height: 50.h,
    child: IconButton(
      onPressed:(){
        print("버튼 누름");
        _kakaoWebViewSetting();
        launchLogin();} , // 함수 호출
      icon: Image.asset(
        'assets/img/kakao_login.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  ),
                  _naverLogin(),
                  _googleLogin(),
                ],
              ),
            ),
            bottomNavigationBar: CustomBottomNavigatorBar(page: 4),
          ),
        );
      },
    );
  }
}

// Widget _kakaoLogin(Function onLogin) {
//   return Container(
//     width: 185.w,
//     height: 50.h,
//     child: IconButton(
//       onPressed:(){
//         print("버튼 누름");
//         onLogin;} , // 함수 호출
//       icon: Image.asset(
//         'assets/img/kakao_login.png',
//         width: double.infinity,
//         height: double.infinity,
//         fit: BoxFit.cover,
//       ),
//     ),
//   );
// }

Widget _naverLogin() {
  return Container(
    width: 185.w,
    height: 50.h,
    child: IconButton(
      onPressed: () {},
      icon: Image.asset(
        'assets/img/naver_login.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _googleLogin() {
  return Container(
    width: 185.w,
    height: 50.h,
    child: IconButton(
      onPressed: () {},
      icon: Image.asset(
        'assets/img/google_login.png'),
    ),
  );
}

class WebViewPage extends StatefulWidget {

  final WebViewController controller;

  WebViewPage({ required this.controller});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KakaoLogin"),
      ),
      body: WebViewWidget(
        controller: widget.controller, // 전달받은 컨트롤러 사용
      ),
    );
  }
}
