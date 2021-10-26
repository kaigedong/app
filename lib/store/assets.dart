import 'package:app/store/types/transferData.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';

class AssetsStore extends GetxController {
  AssetsStore(this.storage);

  final GetStorage storage;

  final String cacheTxsKey = 'txs';

  final String customAssetsStoreKey = 'assets_list';

  List<TransferData> txs = <TransferData>[];

  Map<String, double> marketPrices = Map<String, double>();

  Map<String, bool> customAssets = {};

  Future<void> clearTxs() async {
    txs.clear();
    update();
  }

  Future<void> addTxs(
    Map res,
    KeyPairData acc,
    String pluginName, {
    bool shouldCache = false,
  }) async {
    List ls = res['transfers'];
    if (ls == null) return;

    ls.forEach((i) {
      TransferData tx = TransferData.fromJson(i);
      txs.add(tx);
    });

    if (shouldCache) {
      storage.write('${pluginName}_$acc', ls);
    }
    update();
  }

  void setMarketPrices(Map<String, double> data) {
    marketPrices.addAll(data);
    update();
  }

  void setCustomAssets(
      KeyPairData acc, String pluginName, Map<String, bool> data) {
    customAssets = data;

    _storeCustomAssets(acc, pluginName, data);
    update();
  }

  Future<void> loadAccountCache(KeyPairData acc, String pluginName) async {
    // return if currentAccount not exist
    if (acc == null) {
      return;
    }

    final List cache = await storage.read('${pluginName}_$cacheTxsKey');
    if (cache != null) {
      txs = cache.map((i) => TransferData.fromJson(i)).toList();
    } else {
      txs = [];
    }

    final cachedAssetsList =
        await storage.read('${pluginName}_$customAssetsStoreKey');
    if (cachedAssetsList != null && cachedAssetsList[acc.pubKey] != null) {
      customAssets = Map<String, bool>.from(cachedAssetsList[acc.pubKey]);
    } else {
      customAssets = Map<String, bool>();
    }
    update();
  }

  Future<void> loadCache(KeyPairData acc, String pluginName) async {
    loadAccountCache(acc, pluginName);
  }

  Future<void> _storeCustomAssets(
      KeyPairData acc, String pluginName, Map<String, bool> data) async {
    final cachedAssetsList =
        (await storage.read('${pluginName}_$customAssetsStoreKey')) ?? {};

    cachedAssetsList[acc.pubKey] = data;

    storage.write('${pluginName}_$customAssetsStoreKey', cachedAssetsList);
  }
}
