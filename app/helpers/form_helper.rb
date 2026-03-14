module FormHelper
  def error_border(object, attribute)
    object.errors[attribute].any? ? "border-red-500" : "border-gray-300"
  end
end
