require 'spec_helper'

describe BBConnectSync::MongoDB do
  it 'connects to mongo and allows read/write opperations' do
    BBConnectSync::MongoDB.client do |db|
      db[:cookies].insert_many([
        { title: "Chocolate Chip", rating: 10 },
        { title: "Snickerdoodle", rating: 8 },
        { title: "Oatmeal Raisin", rating: 9 },
        { title: "Lemon Curd", rating: 6 },
      ])

      results = db[:cookies].find({rating: 10})
      expect(results.count).to eql 1
      expect(results.first[:title]).to eql "Chocolate Chip"
      expect(results.first['title']).to eql "Chocolate Chip"

      # Cleanup cookies
      db[:cookies].delete_many
    end
  end
end
