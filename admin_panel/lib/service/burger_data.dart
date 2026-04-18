import 'package:khaikhai_admin/model/burger_model.dart';

List<BurgerModel> getBurger() {
  List<BurgerModel> burger = [];
  BurgerModel burgerModel = BurgerModel();

  burgerModel.name = "Cheese burger";
  burgerModel.image = "images/burger1.png";
  burgerModel.price = "\$12.99";
  burger.add(burgerModel);
  burgerModel = BurgerModel();

  burgerModel.name = "Cheese burger";
  burgerModel.image = "images/burger2.png";
  burgerModel.price = "\$14.99";
  burger.add(burgerModel);
  burgerModel = BurgerModel();

  burgerModel.name = "Veggie burger";
  burgerModel.image = "images/burger2.png";
  burgerModel.price = "\$14.99";
  burger.add(burgerModel);
  burgerModel = BurgerModel();

  burgerModel.name = "Veggie burger";
  burgerModel.image = "images/burger2.png";
  burgerModel.price = "\$14.99";
  burger.add(burgerModel);
  burgerModel = BurgerModel();

  return burger;
}
