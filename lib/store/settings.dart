import 'package:app/service/walletApi.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class SettingsStore extends GetxController {
  SettingsStore(this.storage);

  final GetStorage storage;

  final String localStorageLocaleKey = 'locale';
  final String localStorageNetworkKey = 'network';

  String localeCode = '';

  String network = 'polkadot';

  Map liveModules = Map();

  Map adBannerState = Map();

  Map _disabledCalls;

  Map _xcmEnabledChains;

  Future<Map> getDisabledCalls(String pluginName) async {
    if (_disabledCalls == null) {
      _disabledCalls = await WalletApi.getDisabledCalls();
    }
    return _disabledCalls[pluginName];
  }

  Future<List> getXcmEnabledChains(String pluginName) async {
    if (_xcmEnabledChains == null) {
      _xcmEnabledChains = await WalletApi.getXcmEnabledConfig();
    }
    return _xcmEnabledChains[pluginName] ?? [];
  }

  Future<void> init() async {
    await loadLocalCode();
    await loadNetwork();
  }

  Future<void> setLocalCode(String code) async {
    localeCode = code;
    storage.write(localStorageLocaleKey, code);
    update();
  }

  Future<void> loadLocalCode() async {
    final stored = storage.read(localStorageLocaleKey);
    if (stored != null) {
      localeCode = stored;
    }
    update();
  }

  void setNetwork(String value) {
    network = value;
    storage.write(localStorageNetworkKey, value);
  }

  Future<void> loadNetwork() async {
    final value = await storage.read(localStorageNetworkKey);
    if (value != null) {
      network = value;
    }
  }

  void setLiveModules(Map value) {
    liveModules = value;
    update();
  }

  void setAdBannerState(Map value) {
    adBannerState = value;
  }
}
