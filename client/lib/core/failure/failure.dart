class AppFailure {
  final String message;
  AppFailure({this.message = "Sorry, an unexepected error occurred!"});

  @override
  String toString() => 'AppFailer(message: $message)';
}
