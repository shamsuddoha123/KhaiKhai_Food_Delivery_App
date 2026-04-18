import 'package:khaikhai_admin/model/mexican_model.dart';

List<MexicanModel> getMexican() {
  List<MexicanModel> mexican = [];
  MexicanModel mexicanModel = MexicanModel();

  mexicanModel.name = "Tacos";
  mexicanModel.image = "images/tacos.png";
  mexicanModel.price = "\$12.99";
  mexican.add(mexicanModel);
  mexicanModel = MexicanModel();

  mexicanModel.name = "Tacos";
  mexicanModel.image = "images/tacos.png";
  mexicanModel.price = "\$14.99";
  mexican.add(mexicanModel);
  mexicanModel = MexicanModel();

  mexicanModel.name = "Tacos";
  mexicanModel.image = "images/tacos.png";
  mexicanModel.price = "\$14.99";
  mexican.add(mexicanModel);
  mexicanModel = MexicanModel();

  mexicanModel.name = "Tacos";
  mexicanModel.image = "images/tacos.png";
  mexicanModel.price = "\$14.99";
  mexican.add(mexicanModel);
  mexicanModel = MexicanModel();

  return mexican;
}
