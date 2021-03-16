import 'user.dart';

class Exercise {
  List<List<String>> _exerciseListDatabase = [
    ["Jogging", "240", "assets/images/exercise/jogging.png"],
    ["Cycling", "240", "assets/images/exercise/cycling.png"],
    ["Swimming", "180", "assets/images/exercise/swimming.png"],
    ["Badminton", "135", "assets/images/exercise/badminton.png"],
    ["Tennis", "210", "assets/images/exercise/tennis.png"],
  ];

  String _name;
  String _caloriesBurnedPer30Min;
  String _duration;
  String _totalCaloriesBurned;
  String _date;
  String _imageLocation;

  Exercise(String name, String duration, String weight, String date) {
    User user;
    for (int i = 0; i < _exerciseListDatabase.length; i++) {
      if (name == _exerciseListDatabase[i][0]) {
        this._name = name;
        this._caloriesBurnedPer30Min = _exerciseListDatabase[i][1];
        this._duration = duration;
        this._totalCaloriesBurned =
            ((double.parse(_caloriesBurnedPer30Min) / 30 / 125) *
                    (double.parse(weight) * 2.2046) *
                    double.parse(duration))
                .toStringAsFixed(1);
        this._date = date;
        this._imageLocation = _exerciseListDatabase[i][2];
        break;
      }
    }
  }

  String getName() {
    return this._name;
  }

  String getCaloriesBurnedPer30Min() {
    return this._caloriesBurnedPer30Min;
  }

  String getDuration() {
    return this._duration;
  }

  String getTotalCaloriesBurned() {
    return this._totalCaloriesBurned;
  }

  String getDate() {
    return this._date;
  }

  String getImageLocation() {
    return this._imageLocation;
  }
}
