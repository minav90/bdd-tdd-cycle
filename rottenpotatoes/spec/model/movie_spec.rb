require 'spec_helper'
require 'rails_helper'


describe Movie do
  describe 'searching similar directors' do
    it 'should call Movie with director' do  
      Movie.should_receive(:similar_director).with('George Lucas')
      Movie.similar_director('George Lucas')
    end
   it 'should return array of ratings' do
      Movie.all_ratings
    end
  end
end