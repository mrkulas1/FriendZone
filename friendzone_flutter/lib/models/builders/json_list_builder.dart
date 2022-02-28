/// Abstract class that defines an interface for serializing / deserializing
/// a list of a given type. This should be extended as:
/// XListBuilder extends JsonListBuilder<X> for each model class X where
/// multiple objects can be pulled from a POST request at once.

abstract class JsonListBuilder<T> {
  /// Produce a [List] of type T from a JSON array. Throw exception if the
  /// JSON is in a bad format.
  List<T> listFromJson(List<dynamic> json);

  /// Produce a JSON array from a [List] of type T.
  List<dynamic> listToJson(List<T> obj);
}
