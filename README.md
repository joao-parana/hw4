hw4_rottenpotatoes
==================

hw4_rottenpotatoes from SaaS course
-----------------------------------

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
	

Rodando o Cucumber ele acusa :

    Can't find mapping from "the edit page for "Alien"" to a path

Então altero o arquivo features/suport/paths.rb adicionando 

    # início da alteração
    when /^the (edit|details) page for "(.*)"$/
      movie = Movie.find_by_title($2)
      $1 == "edit" ? edit_movie_path(movie) : movie_path(movie)

Faltam ainda os controlers e views.

Altere a App de forma que possamos editar um video existente adicionando a informação do Nome do Diretor. Comecemos pela View **edit.html.haml**
	
    -# incluir as duas linhas abaixo na View edit.html.haml 
    = label :movie, :director, 'Director'
    = text_field :movie, 'director'	

Agora o Cenário "add director to existing movie" já pode ser testado no Cucumber

Rodando Cucumber ele acusa :

    Undefined step: "the director of "Alien" should be "Ridley Scott""

Então eu copio o arquivo movie_steps.rb do exercicio anterior para nosso diretorio features/step_definitions e rodo o Cucumber novamente.	
	
Depois aceito a sugestão e incluo o código sugerido em movie_steps.rb

    Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
	  pending # express the regexp above with the code you wish you had
	end

e altero o código para refletir a implementação correta:

    Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
	  movie = Movie.find_by_title(title)
	  movie.director.should == director
	end

Rodando o Cucumber novamente verificamos que o Cenário "add director to existing movie" passa pelo teste.

Com isso a primeira parte do _happy path_ do Cenário "search for Movies by Director" fica OK.

Passemos então para o Cenário: "find movie with same director". Precisamos criar um novo link na View show.html.haml

    %br
	= link_to 'Find Movies With Same Director', same_director_path(@movie)
	%br

Precisamos criar um método no Controler **movies_controller**

    def same_director
      id = params[:id]
      @movie = Movie.find(id)
      begin
        @movies = Movie.find_same_director(id)
        rescue Movie::NoDirectorInformation => exception
        flash[:warning] = "'#{@movie.title}' has no director info."
        redirect_to movies_path
      end
    end

No Model (movie.rb) crio a constante: 
 
    class Movie::NoDirectorInformation < StandardError; end

e o método :

    def self.find_same_director(id)
      movie = self.find(id)
      director = movie.respond_to?('director') ? movie.director : ''
      if director and !director.empty?
        self.find_all_by_director(director)
      else
        raise Movie::NoDirectorInformation
      end
    end
	
Precisamos também criar uma entrada em paths.rb

    when /^the Similar Movies page for "(.*)"$/
      movie = Movie.find_by_title($1)
      same_director_path(movie)

Não podemos esquecer de criar o Roteamento em **config/routes.rb**

    match 'movies/same_director/:id' => 'movies#same_director', :as => :same_director
  
A filosifia Rails inclui diversos princípios guia:

* DRY – “Don’t Repeat Yourself” – sugere que escrever o mesmo código várias vezes é uma coisa ruim.
* Convenção ao invés de Configuração – significa que o Rails faz suposições sobre o que você quer fazer e como você estará fazendo isto, em vez de deixá-lo mudar cada minúscula coisa através de intermináveis arquivos de configuração.
* REST é o melhor modelo para aplicações web – organizar sua aplicação em torno de recursos e verbos HTTP padrão é o modo mais rápido para proceder.

Devido as características **Convenção ao invés de Configuração** do Ruby On Rails devemos também criar uma view **app/views/movies/same_director.html.haml**. 

    -#  This file is app/views/movies/same_director.html.haml
	%h1 Movies with the same director (#{@movie.director}) as #{@movie.title}

	%table#movies
	  %thead
	    %tr
	      %th Title
	      %th Rating
	      %th Director
	      %th Release
	      %th More Info
	  %tbody
	    - @movies.each do |movie|
	      %tr
	        %td= movie.title 
	        %td= movie.rating
	        %td= movie.director
	        %td= movie.release_date
	        %td= link_to "More about #{movie.title}", movie_path(movie)
	%br 
	= link_to 'Add new movie', new_movie_path
	%br
	
	
 	



		
		
	
