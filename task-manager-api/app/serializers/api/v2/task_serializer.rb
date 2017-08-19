class Api::V2::TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :done, :deadline, :created_at, :updated_at, :user_id,
  :short_description

  def short_description
    object.description[0...40]
  end
end
