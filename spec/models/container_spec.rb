require 'rails_helper'

RSpec.describe Container, type: :model do
  describe 'create new' do
    it 'should not create an empty container' do
      container = Container.new
      expect(container.save).to be_falsey
    end

    it 'should return empty results' do
      container = Container.new
      expect(container.new_services).to be_empty
      expect(container.metadata).to be_empty
      expect(container.services).to be_empty
      expect(container.report_f).to be_nil
      expect(container.readme_f).to be_nil
    end
  end
end
