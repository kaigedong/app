import 'package:get/get.dart';
import 'package:polkawallet_sdk/api/types/parachain/auctionData.dart';

class ParachainStore extends GetxController {
  AuctionData auctionData = AuctionData();

  Map fundsVisible = {};

  Map userContributions = {};

  void setAuctionData(AuctionData data, Map visible) {
    auctionData = data;
    fundsVisible = visible;
    update();
  }

  void setUserContributions(Map data) {
    userContributions = data;
    update();
  }
}
