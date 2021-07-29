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

  def db_create(model_class, params, _options)
    p model_class.create!(params)
  end

  def db_update(model_class, params, _options)
    p model_class.update!(params)
  end

  def db_user_create(model_class, params, _options)
    user = model_class.create!(params)
    user.confirm
    p user
  end

  def db_user_association_create(model_class, params, options)
    user = User.find_by!(email: options['email'])
    p model_class.create!(params.merge(user: user))
  end

  def db_association_create(model_class, params, options)
    options['associations'] = [options['associations']] if options['associations'].instance_of?(Hash)
    associations = options['associations'].map do |association|
      { association['key'] => association['model'].constantize.find_by!(association['params']) }
    end
    p model_class.create!(params.merge!(*associations))
  end
end

Seed = Struct.new('Seed', :method_name, :data) do
  def execute
    data.each do |model_data|
      Factory.new.send("db_#{method_name}", model_data['model'].constantize, model_data['params'],
                       model_data['options'])
    end
  end
end

json = JSON.parse(ARGV[0])
Seed.new(json['method'], json['data']).execute
