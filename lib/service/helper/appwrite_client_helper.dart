import 'package:appwrite/appwrite.dart';
import 'package:green_cart_scanner/constant/appwrite_contant.dart';


class AppwriteClientHelper {
  static final Client _appwriteClient = Client()
      .setEndpoint(Appconstants.endpoint)
      .setProject(Appconstants.projectid)
      .setSelfSigned(status: true);
  AppwriteClientHelper._();

  static final instance = AppwriteClientHelper._();

  Client get appwriteClient => _appwriteClient;
}
