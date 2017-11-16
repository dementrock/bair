require "google_drive"
require "pry"
require "active_support/all"

def get_sorted_rows
  session = GoogleDrive.saved_session("/root/ruby_google_drive.token", nil, ENV["BAIR_GOOGLE_DRIVE_CLIENT_ID"], ENV["BAIR_GOOGLE_DRIVE_CLIENT_SECRET"])

  bair_software_file = session.file_by_title("BAIR software")

  dict_keys_sub = {
    "Name" => :name,
    "URL of project webpage" => :url,
    "URL to image" => :image_url,
    "Brief description" => :description,
  }

  worksheet = bair_software_file.worksheets.first
  rows = worksheet.rows
  dict_keys = rows[0]
  replaced_keys = dict_keys.map{|x| dict_keys_sub[x]}
  dict_rows = rows[1..-1].map{|row| Hash[replaced_keys.zip(row)]}
  dict_rows.sort_by{|x| x[:name].downcase}
end

if __FILE__ == $0
  get_sorted_rows
end
