Factory.define :user do |f|
  f.name { "Fatory Jose" }
  f.email { "usuario#{rand(10000)}@example.com" }
  f.password { "secret" }
  f.password_confirmation { "secret" }
  f.activated_at { Time.now }
end

Factory.define :region do |f|
  f.name { "Factory Region" }
end