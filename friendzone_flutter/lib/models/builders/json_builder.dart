/// Abstract class that defines an interface for serializing / deserializing
/// a given type. This should be extended as XBuilder extends JsonBuilder<X>
/// for each model class X that is pulled from a POST request.

abstract class JsonBuilder<T> {
  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(T obj);
}
