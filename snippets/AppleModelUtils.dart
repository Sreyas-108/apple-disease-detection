import 'package:tflite/tflite.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppleModelUtils{

  AppleModelUtils()
  {
    initialize();
  }
  void initialize()async{
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: "assets/model.txt",
    );
  }
  Future<int> executeOnDeviceModel(Float32List data) async {
    /*
    * Reference : Tutorial and documentation of tflite: ^1.1.2
    */
    var recognitions = await Tflite.runModelOnBinary(
      binary: data.buffer.asUint8List(),
      numResults: 4,
      threshold: 0.1,
      asynch: true,
    );
    return recognitions[0]["index"];
  }
  Future<AppleModelResponse> executeCloudModelCall(Float32List data) async {
    final response = await http.post(
      Uri.http("x.x.x.x:5000", ''),
      body: jsonEncode(<String, Float32List>{
        'data': data,
      }),
    );
    if (response.statusCode == 200) {
      return AppleModelResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to call model on cloud.');
    }
  }
}