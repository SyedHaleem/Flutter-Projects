import 'package:googleapis_auth/auth_io.dart';
class get_server_key{
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson({
    }), scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}