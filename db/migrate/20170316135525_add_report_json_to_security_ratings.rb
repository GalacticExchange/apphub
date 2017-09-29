class AddReportJsonToSecurityRatings < ActiveRecord::Migration[5.0]
  def change
    add_attachment :security_ratings, :report_json
  end
end
