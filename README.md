hw4_rottenpotatoes
==================

hw4_rottenpotatoes from SaaS course

Para habilitar as cores no Terminal coloque os comandos abaixo no arquivo ~/.bashrc

    export CLICOLOR=1
	export LSCOLORS=GxFxCxDxBxegedabagaced
	alias ls="ls -G"
	alias ll="ls -l"
	git config --global color.ui true
	
Após salvar o arquivo execute o comando abaixo no Terminal.
	
	source ~/.bashrc
	
Para implementar Autenticação na Aplicação veja este link abaixo:

[http://rubysource.com/rails-userpassword-authentication-from-scratch-part-ii](http://rubysource.com/rails-userpassword-authentication-from-scratch-part-ii/) 
	
Novidades após o comando :
    
    bundle install --without production
    
Resultado:

    Installing rspec-core (2.8.0) 
    Installing rspec-expectations (2.8.0) 
    Installing rspec-mocks (2.8.0) 
    Installing rspec (2.8.0) 
    Installing rspec-rails (2.8.1) 
    Installing simplecov-html (0.4.5) 
    Installing simplecov (0.4.2) 


Outros comandos executados:

    rails generate cucumber:install capybara 
	rails generate cucumber_rails_training_wheels:install 
	rails generate rspec:install 
	rake db:migrate
	# rake db:test:prepare
	rake spec
	rake cucumber


Agora alterando o database -  Arquivo db/migrate/20120815134200_add_column_director.rb  :

    class AddColumnDirector < ActiveRecord::Migration
	  def up
	    # add column director on table movies - type is String
	    add_column :movies, :director, :string
	  end

	  def down
	    # remove column director from table movies
	    remove_column :movies, :director
	  end
	end
	
e executando os comandos na console

    rake db:migrate
	rake db:test:prepare
	

Feature provida pelos instrutores em [http://pastebin.com/L6FYWyV7](http://pastebin.com/L6FYWyV7) :

    Feature: search for movies by director

	  As a movie buff
	  So that I can find movies with my favorite director
	  I want to include and serach on director information in movies I enter

	Background: movies in database

	  Given the following movies exist:
	  | title        | rating | director     | release_date |
	  | Star Wars    | PG     | George Lucas |   1977-05-25 |
	  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
	  | Alien        | R      |              |   1979-05-25 |
	  | THX-1138     | R      | George Lucas |   1971-03-11 |

	Scenario: add director to existing movie
	  When I go to the edit page for "Alien"
	  And  I fill in "Director" with "Ridley Scott"
	  And  I press "Update Movie Info"
	  Then the director of "Alien" should be "Ridley Scott"

	Scenario: find movie with same director
	  Given I am on the details page for "Star Wars"
	  When  I follow "Find Movies With Same Director"
	  Then  I should be on the Similar Movies page for "Star Wars"
	  And   I should see "THX-1138"
	  But   I should not see "Blade Runner"

	Scenario: can't find similar movies if we don't know director (sad path)
	  Given I am on the details page for "Alien"
	  Then  I should not see "Ridley Scott"
	  When  I follow "Find Movies With Same Director"
	  Then  I should be on the home page
	  And   I should see "'Alien' has no director info"
	

Então altero o arquivo features/suport/paths.rb adicionando 

    # início da alteração
    when /^the (edit|details) page for "(.*)"$/
      movie = Movie.find_by_title($2)
      $1 == "edit" ? edit_movie_path(movie) : movie_path(movie)

    when /^the Similar Movies page for "(.*)"$/
      movie = Movie.find_by_title($1)
      same_director_path(movie)
    
    # fim da alteração

Faltam ainda os controlers e views.

			
	
	
	
