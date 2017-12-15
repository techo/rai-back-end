# Para traer la data de los JSONs
namespace :seed do
  namespace :users do
    task :dev do
      User.create do |user|
        user.name = 'Dev User'
        user.email = 'dev@user.com'
        user.password = 'p4ssw0rd'
        user.password_confirmation = 'p4ssw0rd'
      end
    end
  end
  # carga país y provincia que no tienen ABM
  namespace :basic do
    task :dev do
      c = Country.create do |country|
        country.name = (0...20).map { ('a'..'z').to_a[rand(26)] }.join
      end
      p = Province.create do |province|
        province.name = (0...20).map { ('a'..'z').to_a[rand(26)] }.join
        province.country = c
      end
    end
  end
end
