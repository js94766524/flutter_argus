class Logger{
  static const bool _isProduct = bool.fromEnvironment("dart.vm.product");
  static bool printLog = !_isProduct;

  static void log(String content){
    if(printLog) print(content);
  }
}