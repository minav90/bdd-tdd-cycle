 require 'spec_helper'
 require 'rails_helper'

class DummyClass
end


 describe 'oddness count' do
    before(:each) do
     @dummy_class = DummyClass.new
     @dummy_class.extend(MoviesHelper)
   end
   it 'should give odd count' do
     @dummy_class.oddness(5) == "true"
   end
 end