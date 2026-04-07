module FoodLabelsHelper
  def label_value_or_placeholder(value, placeholder: "（要入力）")
    value.presence || content_tag(:span, placeholder, class: "text-gray-400")
  end
end
