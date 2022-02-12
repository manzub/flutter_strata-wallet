class AppUrl {
  static const String liveBaseUrl = 'https://accounts.strata.ly/api';
  static const String appServerUrl = 'http://64.227.4.126';

  static const String loginUrl = liveBaseUrl + '/login';
  static const String userInfoUrl = liveBaseUrl + '/user';
  static const String registerUrl = liveBaseUrl + '/register';
  static const String userRecordUrl = liveBaseUrl + '/whome/';
  static const String convertToUsdUrl = liveBaseUrl + '/convert/STRLY/';
  static const String calcGasFeesUrl = liveBaseUrl + '/fees/';
  static const String transferStrataUrl =
      liveBaseUrl + '/transfer/$baseUrlApiKey/';
  static const String walletInfoUrl = liveBaseUrl + '/wallet/details/';

  static const String baseUrlApiKey =
      '0x5883e0d5f3ed1e2ad14014884f230632f48d5871';
  static const String baseUrlApiAccount =
      '1b02af2c11d0c769589fc6cf76e309f7da1d2f08abff09a3ea767d1407ce43df';
}
