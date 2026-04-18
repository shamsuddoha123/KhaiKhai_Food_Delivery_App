import 'package:khaikhai_admin/model/chinese_model.dart';

List<ChineseModel> getChinese() {
  List<ChineseModel> chinese = [];
  ChineseModel chineseModel = ChineseModel();

  chineseModel.name = "Dumplings";
  chineseModel.image = "images/chinese.png";
  chineseModel.price = "\$12.99";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  chineseModel.name = "Peking Duck";
  chineseModel.image = "images/pan.png";
  chineseModel.price = "\$14.99";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  chineseModel.name = "Mapo Tofu";
  chineseModel.image = "images/chinese.png";
  chineseModel.price = "\$14.99";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  chineseModel.name = "Chow Mein";
  chineseModel.image = "images/pan.png";
  chineseModel.price = "\$14.99";
  chinese.add(chineseModel);
  chineseModel = ChineseModel();

  return chinese;
}
