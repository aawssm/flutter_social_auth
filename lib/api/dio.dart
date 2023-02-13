import 'package:dio/dio.dart';

import '../cmn.dart';

List<String> baseDiol = ["http://localhost:3000/"];

int ctReTry = 0;

class ApiDio {
  final ProAppSettings _authState = ProAppSettings();
  Map<String, String>? accessHeader;
  bool isAuth = false;
  String xAccessToken = "";
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  ApiDio() {
    updateHeader();
    if (kIsWeb) {
      baseDiol = ["http://localhost:3000/"];
    } else if (Platform.isAndroid) {
      baseDiol = ["10.0.2.2:3000"];
    }
  }
  Future<Map<String, String>> updateHeader() async {
    if (xAccessToken.isEmpty) xAccessToken = await _authState.getToken();
    if (xAccessToken.isNotEmpty) {
      headers["x-access-token"] = xAccessToken;
      isAuth = true;
    }
    headers["x-access-api"] = "";
    return headers;
  }

  Future<bool> apiClearToken({String str = ""}) async {
    xAccessToken = str;
    return true;
  }

  Future<String> reqUrlMaker(int v, String endpoint) async {
    await updateHeader();
    String baseurl = baseDiol[ctReTry];
    String baseurlv1 = baseurl;
    String baseurAApiDios = "${baseurl}apis/";

    String url = (v == 0 ? baseurAApiDios : baseurlv1) + endpoint;
    //print(url);
    return url;
  }

  Future<MoResponse> getAsync(String endPoint, {int apiVersion = 1}) async {
    return aioHandler("get", endPoint, apiVersion: apiVersion);
  }

  Future<MoResponse> postAsync(String endPoint, Map<String, dynamic> data,
      {List<String>? files, int apiVersion = 1}) async {
    return aioHandler("post", endPoint, data: data, files: files, apiVersion: apiVersion);
  }

  Future<MoResponse> postMultiAsync(String endPoint, List dataLS,
      {List<String>? files, int apiVersion = 0}) async {
    return aioHandler("posts", endPoint, dataLS: dataLS, files: files, apiVersion: apiVersion);
  }

  Future<MoResponse> putAsync(String endPoint, Map<String, dynamic> data,
      {List<String>? files, int apiVersion = 1}) async {
    return aioHandler("put", endPoint, data: data, files: files, apiVersion: apiVersion);
  }

  // Future<dynamic> patchAsync(String endPoint, Map data, {List<String>? files, int ApiDioVersion = 1}) async {
  //   return aioHandler("patch", endPoint, data: data, files: files, ApiDioVersion: ApiDioVersion);
  // }

  Future<MoResponse> deletAsync(String endPoint, {int apiVersion = 1}) async {
    return aioHandler("delete", endPoint, apiVersion: apiVersion);
  }

  Future<MoResponse> aioHandler(String casee, String endPoint,
      {Map<String, dynamic>? data,
      List? dataLS,
      List<String>? files,
      int apiVersion = 1,
      bool authOnly = false}) async {
    String reqUrl = await reqUrlMaker(apiVersion, endPoint);
    int tempctReTry = ctReTry;
    //if (kDebugMode) print("aoi case : " + casee + " endpoint : " + reqUrl);
    if (authOnly == true && isAuth == false) {
      return MoResponse(status: "ok", result: [], success: false, message: "Auth requierd");
    }
    if (kDebugMode) print("aoi case : $casee endpoint : $reqUrl");
    try {
      final stopwatch = Stopwatch()..start();
      // await updateHeader();
      var dio = Dio();
      Map<String, dynamic> mapStringDy = {};
      List<dynamic> mfileArrya = [];
      if (casee == "posts") {
        if (dataLS == null) throw Exception("No data to posts");
        mapStringDy = {"body": jsonEncode(dataLS.map((e) => e.toJson()).toList())};
      } else if (casee != "get" && casee != "delete") {
        if (data == null) throw Exception("No data to post");
        mapStringDy.addAll({"body": jsonEncode(data)});
      }
      //add files doesnt exist
      if (files != null) {
        for (int i = 0; i < files.length; i++) {
          mfileArrya.add(MultipartFile.fromFileSync(files[i]));
        }
        //add files to master req
        mapStringDy.addAll({"files": mfileArrya});
      }
      late Response response;
      switch (casee) {
        case "get":
          response = await dio.get(reqUrl, options: Options(headers: headers));
          break;
        case "post":
          response =
              await dio.post(reqUrl, data: FormData.fromMap(mapStringDy), options: Options(headers: headers));
          break;
        case "put":
          response =
              await dio.put(reqUrl, data: FormData.fromMap(mapStringDy), options: Options(headers: headers));
          break;
        case "patch":
          response = await dio.patch(reqUrl,
              data: FormData.fromMap(mapStringDy), options: Options(headers: headers));
          break;
        case "delete":
          response = await dio.delete(reqUrl, options: Options(headers: headers));
          break;
        case "posts":
          response =
              await dio.post(reqUrl, data: FormData.fromMap(mapStringDy), options: Options(headers: headers));
          break;
        default:
          throw Exception("No case found");
      }
      // //print('$casee executed in ${stopwatch.elapsed} '); //$reqUrl
      if (kDebugMode) print('executed in ${stopwatch.elapsed} $casee $reqUrl');

      return MoResponse.fromJson(response.data);
    } on SocketException {
      if (ctReTry < baseDiol.length) {
        //print("here");
        if (tempctReTry == ctReTry) ctReTry++;
        return aioHandler(casee, endPoint, apiVersion: apiVersion);
      } else {
        throw MoResponse(status: "ok", result: [], success: false, message: "Error No internet");
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return MoResponse(status: "ok", result: [], success: false, message: "Error $e");
    }
  }
  ///////////////////////////////////////////////////end of class//////////////////////////////////////////////
}
