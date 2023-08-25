// ignore_for_file: file_names, constant_identifier_names

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalFutBit {

  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static void futCurScnBit(String futScnNmBt, String futClNmBt){
    analytics.setCurrentScreen(
        screenName: futScnNmBt,screenClassOverride: futClNmBt
    );
  }

  static const String Fut_Frm_Bit_Scn = 'BitCode Frame Screen';
  static const String Fut_Con_Bit_Scn = 'BitCode Coin Screen';
  static const String Fut_Trd_Bit_Scn = 'BitCode Trend Screen';
  static const String Fut_Gan_Bit_Scn = 'BitCode Top Coin Screen';
}