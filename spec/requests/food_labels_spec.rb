require 'rails_helper'

RSpec.describe "FoodLabels", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:product) { create(:product, user: user) }

  let(:valid_params) do
    {
      food_label: {
        product_name: "焼菓子",
        content_quantity: "1個",
        expiration_date: "製造日から30日",
        storage_method: "直射日光、高温多湿を避けて保存してください",
        manufacturer_name: "テスト製菓",
        manufacturer_address: "東京都渋谷区1-1-1"
      }
    }
  end

  describe "GET /products/:product_id/food_label/edit" do
    context "ログイン時" do
      before { sign_in user }

      it "食品表示ラベル編集画面が表示される" do
        get edit_product_food_label_path(product)
        expect(response).to have_http_status(:ok)
      end

      it "他ユーザーの商品にはアクセスできない" do
        other_product = create(:product, user: other_user)
        get edit_product_food_label_path(other_product)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログイン時" do
      it "リダイレクトされる" do
        get edit_product_food_label_path(product)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /products/:product_id/food_label" do
    context "ログイン時" do
      before { sign_in user }

      it "有効なパラメータで食品表示ラベルが作成される" do
        expect {
          patch product_food_label_path(product), params: valid_params
        }.to change(FoodLabel, :count).by(1)
        expect(response).to redirect_to(edit_product_food_label_path(product))
        expect(flash[:notice]).to eq("食品表示ラベルを保存しました")
      end

      it "既存のラベルを更新できる" do
        create(:food_label, product: product)
        patch product_food_label_path(product), params: { food_label: { content_quantity: "2個" } }
        expect(product.food_label.reload.content_quantity).to eq("2個")
        expect(response).to redirect_to(edit_product_food_label_path(product))
      end

      it "無効なパラメータではエラーが表示される" do
        expect {
          patch product_food_label_path(product), params: { food_label: { product_name: "" } }
        }.not_to change(FoodLabel, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "他ユーザーの商品にはアクセスできない" do
        other_product = create(:product, user: other_user)
        patch product_food_label_path(other_product), params: valid_params
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログイン時" do
      it "リダイレクトされる" do
        patch product_food_label_path(product), params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
