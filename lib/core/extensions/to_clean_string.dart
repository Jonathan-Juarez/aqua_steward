extension NumFormatExtension on num {
  // Redondea un número a máximo 1 decimal sin mostrar .0 en enteros.
  String toCleanString({int maxDecimals = 1}) {
    // Se comprueba si el número es entero. Si lo es, se convierte a int y se retorna como String. De lo contrario, se convierte a String con la precisión deseada.
    return this % 1 == 0 ? toInt().toString() : toStringAsFixed(maxDecimals);
  }
}
