import 'package:googleapis_auth/auth_io.dart';
class get_server_key{
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "peak-565020764355f04317d07cb81dc2e17c4148f175catbird-459818-j8",
      "private_key_id": "",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCvBKnTAwXD6lZN\nA/s40WW4ilfumaWAZMTMI6lcoVUks3rELm55oTxo9tyWY04lHYZATbEKsGObA2jp\nBCmsLvfvzbHFHdj7CaZ2TGfjK7zVxK8EqpKYzQNyr85mOYA8H8CqkBvH209xeroo\nJURGSUH9oztamx1EshF6QyR+aV7m6p9ciO+01WZzj1bbHy4b2n24GR6JPYePG9qE\nWyDW271fnMTk/YRCdhnKXwhFSjuP6bCyMDGFuFSu4UvjxODQPkdYDF0nV3KLbdeX\nOYr2/IYIOjmGueQVvA53d3h83PzgnOnw35zEfNegpLFCGSJtuXhoDcVNY/yvVwKO\nufiT2iiBAgMBAAECggEAHk8i79mOpoqPDoBZgdH1mTtQFhCCslUBJc8pNdL0sUnp\nwU6/MA4lrZHOyraA4nmV9c3ekpjQbxhskyn244wwwNUw64+LM5JMwyDhPtyks6p/\nmsHFaHPcnIBosJhVplPjZEZXoUlQHTlhQrGNfNST+o5JqZvCOlLSJwe4qrGpzzhZ\nvJwUL1RRigu+A+qgZRytDh8nn7r59KjE6Ffm92RoWcr5gJqCV9TINz5EdOyeYMMM\nmuOxsQwm/rkrvNYS7kN6ZX9sIFoyTRREYNI1rzKf0wUZkN9YuOXkN21gtabjXWUj\nzt/LKOiB4vPRmqw+wJzjPuc+cdsLJCtRO1Pfsmi/CQKBgQDtTPC4rTG9PBxwXWBI\n6EFgV5X9GvszzBdMmCG/BV3RvTIxNu1dEya8WjwulsxbVQh16AHBa9XBn5bQnIM2\nJRdRAdkIBM7tlvIWbOgBMqUzLOz0lrqMVQC3VNi4nEcdaGoi8/au7rch8gAsMON4\nVVZf5haapKuGdcfHZmSILH2SrQKBgQC8z019yk8uJHvuxAQRVqBFxKgJvPdYvl29\nUl+hVF1vKmNf9QYyHee66ObS+mcFERXG6M5Hkt41ejm5KSX+4qGBdonpQ//K1rga\nsDWUbUGodwTw/AWT0Gq+t3zscog/qivTUIL5kiggXKtXe0tPBGBv83H84RmFRrXq\nve825uf7pQKBgHMi37FbJ0T/w3SpeawmNIJAPN//lV5+adeaANWkDu9S8uV6FxUP\n072TspuQQzsVOPOsTB3C6oX1nsE9D1TYDkYZtWn0m0of8Pn8gV0Da7A23gmWkJDC\nNYS+QCDigoa8QLMQ1+HspSJtPrQyTEv4a94/zzvdJfQpdXNENQb1P0BJAoGAHnsI\n84m5hqV1LHKQhYwKi7jXt9q9w6HX2Dx4G79W5h9ds5wGyAhz5IS83sp13yeG8Hmc\n84kOPmvg7bdq3t8PW6sbUIEdxk0ro4NW4wNQWjX8ojrNW7OFyAwvKqzCuiRqts6E\nlm219KOBNbo9yh/Wwbv3Zu+gAxgLPj4zZBWa1dECgYEArwO0z1g0mU4+JzRPXcCZ\nuqODURFAc5JTeKCh4xaSXBKtUkGXw1D30D7NKWhfyTv/KDD7SZtgLqEARGw4gkhF\nFcnbveZUl3+b/JuiILnttjg0j9n+tNh1SYsdeTkKE87xHCDwmISBR30JHlOhUEUo\ngV3tEbZ/nJJpQnU/7AFXdy0=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@peak-catbird-459818-j8.iam.gserviceaccount.com",
      "client_id": "102580429457209047640",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40peak-catbird-459818-j8.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }), scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}