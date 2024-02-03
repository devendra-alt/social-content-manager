

class AgoraException implements Exception{
  final String message;

  AgoraException({required this.message});


  @override
  String toString() {
    return message;
  }


}