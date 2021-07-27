# frozen_string_literal: true

module IdGenerator
  def generate_uuid(column_name)
    loop do
      uuid = SecureRandom.uuid
      break uuid unless self.class.exists?(column_name => uuid)
    end
  end
end
