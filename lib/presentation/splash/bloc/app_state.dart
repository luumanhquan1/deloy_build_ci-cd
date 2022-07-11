
import 'package:ccvc_mobile/domain/locals/prefs_service.dart';

import 'package:rxdart/rxdart.dart';

class AppState {
  String token = '';
  final BehaviorSubject<String> getToken = BehaviorSubject<String>();
  void getTokenPrefs() {
    token = PrefsService.getUserId();
    getToken.sink.add(token);
  }

  void setToken(String token) {
    PrefsService.saveToken(token);
    this.token = token;
    getToken.sink.add(token);
  }
}
