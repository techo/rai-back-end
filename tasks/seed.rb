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
end
