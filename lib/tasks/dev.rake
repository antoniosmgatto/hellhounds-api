namespace :dev do

  desc 'setup development environment'
  task setup: :environment do
    images_path = Rails.root.join('public', 'system')

    puts 'executando basic_setup'

    puts "apagando DB... #{%x(rake db:drop)}"

    if Rails.env.development?
        puts "Apagando imagens... #{%x(find #{images_path} -type f -name *.jpg -exec rm -rf {} ';')}"
    end

    puts "criando DB... #{%x(rake db:create)}"
    puts %x(rake db:migrate)

    puts 'finalizado basic setup'
  end
end