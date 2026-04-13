module ApplicationHelper
  def pagy_info_text(pagy)
    "全#{pagy.count}件中 #{pagy.from}〜#{pagy.to}件を表示"
  end
end
