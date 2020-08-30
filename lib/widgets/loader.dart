import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String message;
  final bool retry;
  final Function retryFunction;
  final Function offLineMode;
  Loader({this.message, this.retry, this.retryFunction, this.offLineMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          if (this.message != null) Text(this.message),
          if (this.retry != null && this.retry)
            FlatButton(
                onPressed: () {
                  retryFunction();
                },
                child: Text("Retry")),
          if(this.offLineMode != null)
            FlatButton(
                onPressed: () {
                  offLineMode();
                },
                child: Text("Go Offline")),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
