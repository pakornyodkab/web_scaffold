json.extract! user, :id, :name, :email, :birthdate, :created_at, :updated_at
json.url user_url(user, format: :json)
