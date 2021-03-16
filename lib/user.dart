import 'food.dart';
import 'exercise.dart';

class User {
  String _name,
      _dob,
      _gender,
      _email,
      _phone,
      _password,
      _height = "0.0",
      _weight = "0.0";

  List<Food> _foodList = [];
  List<Exercise> _exerciseList = [];

  User(String name, String dob, String gender, String email, String phone,
      String password) {
    this._name = name;
    this._dob = dob;
    this._gender = gender;
    this._email = email;
    this._phone = phone;
    this._password = password;
  }

  String getName() {
    return this._name;
  }

  String getDob() {
    return this._dob;
  }

  String getGender() {
    return this._gender;
  }

  String getEmail() {
    return this._email;
  }

  String getPhone() {
    return this._phone;
  }

  String getPassword() {
    return this._password;
  }

  String getHeight() {
    return this._height;
  }

  String getWeight() {
    return this._weight;
  }

  List<Food> getFoodList() {
    return this._foodList;
  }

  List<Exercise> getExerciseList() {
    return this._exerciseList;
  }

  void setName(String name) {
    this._name = name;
  }

  void setDob(String dob) {
    this._dob = dob;
  }

  void setGender(String gender) {
    this._gender = gender;
  }

  void setEmail(String email) {
    this._email = email;
  }

  void setPhone(String phone) {
    this._phone = phone;
  }

  void setPassword(String password) {
    this._password = password;
  }

  void setHeight(String height) {
    this._height = height;
  }

  void setWeight(String weight) {
    this._weight = weight;
  }

  void setFoodList(Food food) {
    this._foodList.add(food);
  }

  void setExerciseList(Exercise exercise) {
    this._exerciseList.add(exercise);
  }
}
