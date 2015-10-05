 require 'spec_helper'
 require 'rails_helper'

describe MoviesController, :type => :controller do 

describe 'create,destroy,update,edit and show' do
    it 'should create a new movie' do
       m = double(Movie, :id => "10", :title => "blah", :director => nil)
      Movie.stub(:create).and_return(m)
      post :create, {:id => "10"}
      response.should redirect_to(movies_path)
    end
    it 'should destroy a movie' do
      m = double(Movie, :id => "10", :title => "blah", :director => nil)
      Movie.stub(:find).with("10").and_return(m)
      m.should_receive(:destroy)
      delete :destroy, {:id => "10"}
      response.should redirect_to(movies_path)
    end
    it 'should call update_attributes and redirect' do 
      m = double(Movie, :id => "10", :title => "blah", :director => nil)
      Movie.stub(:find).with("10").and_return(m)
      m.stub(:update_attributes!).and_return(true)
      post :update, {:id => "10", :movie => m}
      response.should redirect_to(movie_path(m))
    end
    it 'should edit a movie' do
     m = double(Movie, :id => "10", :title => "blah", :director => nil)
     Movie.stub(:find).with("10").and_return(m)
     post :edit, {:id => "10"}
    end
    it 'should show a movie' do
     m = double(Movie, :id => "10", :title => "blah", :director => nil)
     Movie.stub(:find).with("10").and_return(m)
     post :show, {:id => "10"}
    end
  end

  describe 'add director' do
    before :each do
      @m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub(:find).with("1").and_return(@m)
    end
    it 'should call update_attributes and redirect' do
      @m.stub(:update_attributes!).and_return(true)
      put :update, {:id => "1", :movie => @m}
      response.should redirect_to(movie_path(@m))
    end
  end

  describe 'happy path' do
    before :each do
      @m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub(:find).with("1").and_return(@m)
    end
    
    it 'should generate routing for Similar Movies' do
      { :post => movie_similar_path(1) }.
      should route_to(:controller => "movies", :action => "similar", :movie_id => "1")
    end
    it 'should call the model method that finds similar movies' do
      fake_results = [double('Movie'), double('Movie')]
      Movie.should_receive(:similar_director).with('director').and_return(fake_results)
      get :similar, :movie_id => "1"
    end
    it 'should select the Similar template for rendering and make results available' do
      Movie.stub(:similar_director).with('director').and_return(@m)
      get :similar, :movie_id => "1"
      response.should render_template('similar')
      assigns(:movies).should == @m
    end
  end

   describe 'sad path' do
    before :each do
      m=double(Movie, :title => "Star Wars", :director => nil, :id => "1")
      Movie.stub(:find).with("1").and_return(m)
    end
    
    it 'should generate routing for Similar Movies' do
      { :post => movie_similar_path(1) }.
      should route_to(:controller => "movies", :action => "similar", :movie_id => "1")
    end
    it 'should select the Index template for rendering and generate a flash' do
      get :similar, :movie_id => "1"
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end

  describe 'index should be called' do
    it 'should process index method with sort on title' do
         get :index,{:sort => "title"}
     end
     it 'should process index method with sort on release_date' do
         get :index,{:sort => "release_date"}
     end
     it 'should process index method with sort on release_date and ratings = G' do
         get :index,{:sort => "release_date",:ratings => ['G','PG']},{:sort => "release_date",:ratings=>""}
          get :index,{:sort => "release_date",:ratings => {'G'=>"ratings_G",'PG'=>"ratings_PG"}},{:sort => "release_date",:ratings=>{'G'=>"ratings_G",'PG'=>"ratings_PG"}}
     end
     it 'should process index method with sort different on param and session' do
         get :index,{:sort => "release_date"},{:sort => "title"}
     end
  end
end