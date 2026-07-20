class StateParameters {
  static String getBodyText(double inputValue, String unit) {
    if (unit == "pH") {
      if (inputValue >= 0 && inputValue < 2) {
        return "Muy ácido";
      } else if (inputValue >= 2 && inputValue < 6.5) {
        return "Ácido";
      } else if (inputValue >= 6.5 && inputValue <= 8.5) {
        return "Óptimo";
      } else if (inputValue > 8.5 && inputValue <= 12) {
        return "Alcalino";
      } else {
        return "Muy alcalino";
      }
    }
    if (unit == "NTU") {
      if (inputValue <= 1) {
        return "Ideal";
      } else if (inputValue <= 5) {
        return "Aceptable";
      } else if (inputValue <= 30) {
        return "Ligeramente turbio";
      } else if (inputValue <= 100) {
        return "Turbio";
      } else {
        return "Muy turbio";
      }
    }
    return "";
  }
}
