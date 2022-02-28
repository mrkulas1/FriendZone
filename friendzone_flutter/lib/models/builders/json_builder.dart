/// Abstract class that defines an interface for serializing / deserializing
/// a given type. This should be extended as XBuilder extends JsonBuilder<X>
/// for each model class X that is pulled from a POST request.

abstract class JsonBuilder<T> {
  /// Produce an object of type T from a JSON map. Throw an exception if the
  /// JSON is incorrectly formed.
  T fromJson(Map<String, dynamic> json);

  /// Produce a JSON map from an object of type T.
  Map<String, dynamic> toJson(T obj);
}
