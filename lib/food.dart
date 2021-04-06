class Food {
  // List<List<String>> _foodListDatabase = [
  //   ["Banana", "89", "assets/images/food/banana.png"],
  //   ["Apple", "52", "assets/images/food/apple.png"],
  //   ["Kuey Teow Soup", "65.5", "assets/images/food/kueyteowsoup.png"],
  //   ["Fried Chicken", "246", "assets/images/food/friedchicken.png"],
  //   ["Orange", "47", "assets/images/food/orange.png"],
  //   ["Fried Rice", "163", "assets/images/food/friedrice.png"],
  //   ["Mango", "60", "assets/images/food/mango.png"],
  //   ["Nasi Lemak", "192.4", "assets/images/food/nasilemak.png"],
  //   ["Chicken Chop", "239", "assets/images/food/chickenchop.png"],
  //   ["Roti Canai", "318", "assets/images/food/roticanai.png"],
  // ];

  List<dynamic> _foodList;

  // String _caloriesPer100g;
  // String _amount;
  // String _totalCalories;
  // String _date;
  // String _imageLocation;

  // Food(String name, String amount, String date) {
  //   for (int i = 0; i < _foodListDatabase.length; i++) {
  //     if (name == _foodListDatabase[i][0]) {
  //       this._name = name;
  //       this._caloriesPer100g = _foodListDatabase[i][1];
  //       this._amount = amount;
  //       this._totalCalories =
  //           (double.parse(_foodListDatabase[i][1]) / 100 * double.parse(amount))
  //               .toStringAsFixed(1);
  //       this._date = date;
  //       this._imageLocation = _foodListDatabase[i][2];
  //       break;
  //     }
  //   }
  // }

  Food(List<dynamic> json) {
    this._foodList = json;
  }

  List<dynamic> getFoodList() {
    return this._foodList;
  }

  // String getCaloriesPer100g() {
  //   return this._caloriesPer100g;
  // }

  // String getAmount() {
  //   return this._amount;
  // }

  // String getTotalCalories() {
  //   return this._totalCalories;
  // }

  // String getDate() {
  //   return this._date;
  // }

  // String getImageLocation() {
  //   return this._imageLocation;
  // }
}
