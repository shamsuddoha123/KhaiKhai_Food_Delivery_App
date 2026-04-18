import 'package:khaikhai/model/pizza_model.dart';

List<PizzaModel> getPizza() {
  List<PizzaModel> pizza = [];
  PizzaModel pizzaModel = PizzaModel();

  pizzaModel.name = "Cheese pizza";
  pizzaModel.image = "images/pizza1.png";
  pizzaModel.price = "\$12.99";
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel();

  pizzaModel.name = "Margherita pizza";
  pizzaModel.image = "images/pizza2.png";
  pizzaModel.price = "\$14.99";
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel();

  pizzaModel.name = "Margherita pizza";
  pizzaModel.image = "images/pizza2.png";
  pizzaModel.price = "\$14.99";
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel();

  pizzaModel.name = "Margherita pizza";
  pizzaModel.image = "images/pizza2.png";
  pizzaModel.price = "\$14.99";
  pizza.add(pizzaModel);
  pizzaModel = PizzaModel();

  return pizza;
}