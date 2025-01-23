// Configuración para el funcionamiento de BLe
abstract class ReactiveState<T> {
  Stream<T> get state;
}
