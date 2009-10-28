Factory.define :user do |f|
  f.name { "Roland Crim" }
  f.email { "usuario#{rand(10000)}@example.com" }
  f.password { "secret" }
  f.password_confirmation { "secret" }
end

Factory.define :region do |f|
  f.name { "Factory Region" }
end