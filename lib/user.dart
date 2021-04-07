class User {
  String _name, _dob, _gender, _email, _phone, _height, _weight;

  List _foodList = [];
  List _exerciseList = [];
  List _userFoodList = [];
  List _userExerciseList = [];

  User(String name, String dob, String gender, String email, String phone,
      String height, String weight) {
    this._name = name;
    this._dob = dob;
    this._gender = gender;
    this._email = email;
    this._phone = phone;
    this._height = height;
    this._weight = weight;
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

  String getHeight() {
    return this._height;
  }

  String getWeight() {
    return this._weight;
  }

  List getFoodList() {
    return this._foodList;
  }

  List getExerciseList() {
    return this._exerciseList;
  }

  List getUserFoodList() {
    return this._userFoodList;
  }

  List getUserExerciseList() {
    return this._userExerciseList;
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

  void setHeight(String height) {
    this._height = height;
  }

  void setWeight(String weight) {
    this._weight = weight;
  }

  void setFoodList(List foodList) {
    this._foodList = foodList;
  }

  void setExerciseList(List exerciseList) {
    this._exerciseList = exerciseList;
  }

  void setUserFoodList(List userFoodList) {
    this._userFoodList = userFoodList;
  }

  void setUserExerciseList(List userExerciseList) {
    this._userExerciseList = userExerciseList;
  }
}
