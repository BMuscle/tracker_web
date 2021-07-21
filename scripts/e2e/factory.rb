# frozen_string_literal: true

# 使い方
# JSON文字列を第1引数に渡す
# JSONの構造は以下の通り
#
# method: class Factoryに存在するメソッド名
# data: Array
#       model: 操作を行うモデル名
#       params: 挿入するデータ

class Factory
  include FactoryBot::Syntax::Methods

  def db_create(model_class, params)
    p model_class.create!(params)
  end

  def db_update(model_class, params)
    p model_class.update!(params)
  end

  def db_user_create(model_class, params)
    user = model_class.create!(params)
    user.confirm
    p user
  end
end

Seed = Struct.new('Seed', :method_name, :data) do
  def execute
    data.each do |model_data|
      Factory.new.send("db_#{method_name}", model_data['model'].constantize, model_data['params'])
    end
  end
end

json = JSON.parse(ARGV[0])
Seed.new(json['method'], json['data']).execute
