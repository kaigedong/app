import 'package:get/get.dart';
import 'package:polkawallet_sdk/api/types/recoveryInfo.dart';
import 'package:polkawallet_sdk/api/types/walletConnect/pairingData.dart';

class AccountStore extends GetxController {
  AccountStore();

  AccountCreate newAccount = AccountCreate();

  bool accountCreated = false;

  Map<int, Map<String, String>> pubKeyAddressMap =
      Map<int, Map<String, String>>();

  Map<String, String> addressIconsMap = Map<String, String>();

  RecoveryInfo recoveryInfo = RecoveryInfo();

  bool showBanner = false;

  bool walletConnectPairing = false;

  List<WCPairedData> wcSessions = <WCPairedData>[];

  void setNewAccount(String name, String password) {
    newAccount.name = name;
    newAccount.password = password;
    update();
  }

  void setNewAccountKey(String key) {
    newAccount.key = key;
    update();
  }

  void resetNewAccount() {
    newAccount = AccountCreate();
    update();
  }

  void setAccountCreated() {
    accountCreated = true;
    update();
  }

  void setPubKeyAddressMap(Map<String, Map> data) {
    data.keys.forEach((ss58) {
      // get old data map
      Map<String, String> addresses =
          Map.of(pubKeyAddressMap[int.parse(ss58)] ?? {});
      // set new data
      Map.of(data[ss58]).forEach((k, v) {
        addresses[k] = v;
      });
      // update state
      pubKeyAddressMap[int.parse(ss58)] = addresses;
    });
    update();
  }

  void setAddressIconsMap(List list) {
    list.forEach((i) {
      addressIconsMap[i[0]] = i[1];
    });
    update();
  }

  void setAccountRecoveryInfo(RecoveryInfo data) {
    recoveryInfo = data ?? RecoveryInfo();
    update();
  }

  void setWCPairing(bool pairing) {
    walletConnectPairing = pairing;
    update();
  }

  void setWCSessions(List<WCPairedData> sessions) {
    wcSessions = sessions;
    update();
  }

  void createWCSession(WCPairedData session) {
    wcSessions.add(session);
    update();
  }

  void deleteWCSession(WCPairedData session) {
    wcSessions.removeWhere((e) => e.topic == session.topic);
    update();
  }

  void setBannerVisible(bool visible) {
    showBanner = visible;
    update();
  }
}

class AccountCreate extends GetxController {
  String name = '';

  String password = '';

  String key = '';
}
