require 'test_helper'

describe PetsController do
  # before do
  #   PET_FIELDS = ["age", "human", "id", "name"]
  # end
  
  describe "index" do
    it "responds with JSON and success" do
      get pets_path
      
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end
    
    it "responds with an array of pet hashes" do
      # Act
      get pets_path
      
      # Get the body of the response
      body = JSON.parse(response.body)
      
      # Assert
      expect(body).must_be_instance_of Array
      body.each do |pet|
        expect(pet).must_be_instance_of Hash
        expect(pet.keys.sort).must_equal ["age", "human", "id", "name"]
      end
    end
    
    it "will respond with an empty array when there are no pets" do
      # Arrange
      Pet.destroy_all
      
      # Act
      get pets_path
      body = JSON.parse(response.body)
      
      # Assert
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
    end
  end
  
  describe "show" do
    it "retrieves one pet" do
      # Arrange
      pet = Pet.first
      
      # Act
      get pet_path(pet)
      body = JSON.parse(response.body)
      
      # Assert
      must_respond_with :success
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal ["age", "human", "id", "name"]
    end
    
    it "sends back not found if the pet does not exist" do
      # Act
      get pet_path(-1)
      body = JSON.parse(response.body)
      
      # Assert
      must_respond_with :not_found
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Hash
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal "no pet by that ID"
    end
  end
  
  describe "create" do
    let(:pet_data) {
      {
        pet: {
          age: 13,
          name: 'Stinker',
          human: 'Grace'
        }
      }
    }
    it "can create a new pet" do
      expect {
        post pets_path, params: pet_data
      }.must_differ 'Pet.count', 1
      
      must_respond_with :created
    end
    
    it "will respond with bad_request for invalid data" do
      pet_data[:pet][:age] = nil
      
      expect {
        post pets_path, params: pet_data
      }.wont_change "Pet.count"
      
      must_respond_with :bad_request
      
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "age"
    end
  end
end
