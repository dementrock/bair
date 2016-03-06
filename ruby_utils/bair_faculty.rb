require_relative "./settings"
require "google/api_client"
require "google_drive"
require "pry"
require "active_support/all"
require "firebase"
require "cloudinary"

def get_faculty_list
  session = GoogleDrive.saved_session(nil, nil, ENV["BAIR_GOOGLE_DRIVE_CLIENT_ID"], ENV["BAIR_GOOGLE_DRIVE_CLIENT_SECRET"])

  dict_keys_sub = {
    "First Name" => :first_name,
    "Last Name" => :last_name,
    "Url" => :url,
    "Image Url" => :image_url,
    "Steering" => :steering,
    "Emeritus" => :emeritus,
    "Zoom" => :zoom,
  }

  bair_current_file = session.file_by_title("BAIR Faculty")
  worksheet = bair_current_file.worksheets.first
  rows = worksheet.rows
  dict_keys = rows[0]
  replaced_keys = dict_keys.map{|x| dict_keys_sub[x]}
  dict_rows = rows[1..-1].map{|row| Hash[replaced_keys.zip(row)]}
  dict_rows.sort_by{|x| x[:last_name]}
end

def ensure_faculty_face_images!(sorted_rows)
  base_uri = "https://bair-dev.firebaseio.com"
  cli = Firebase::Client.new(base_uri)
  cli_key = "faculty_processed_images"
  processed_images = cli.get(cli_key).body || {}
  processed_keys = processed_images.keys
  todo_images = sorted_rows.map{|x| [x[:image_url], x]}.reject{|x| processed_keys.include?(Digest::MD5.hexdigest(x[0]))}

  Cloudinary.config do |config|
    config.cloud_name = ENV["CLOUDINARY_CLOUD_NAME"]
    config.api_key = ENV["CLOUDINARY_API_KEY"]
    config.api_secret = ENV["CLOUDINARY_API_SECRET"]
  end

  todo_images.each do |image_url, content|
    STDERR.puts "Processing #{image_url}..."
    STDERR.puts "Uploading image..."
    begin
      ret = Cloudinary::Uploader.upload image_url
      processed_images = cli.get(cli_key).body || {}
      processed_images[Digest::MD5.hexdigest(image_url)] = ret
      # save after every update
      cli.set(cli_key, processed_images)
    rescue Exception => e
      STDERR.puts e
      STDERR.puts content
      STDERR.puts "Continuing"
    end
  end
  sorted_rows.each do |row|
    unless row[:image_url].blank?
      key = Digest::MD5.hexdigest(row[:image_url])
      if processed_images.include?(key)
        id = processed_images[key]["public_id"]
        row[:remote_cropped_image_url] = Cloudinary::Utils.cloudinary_url(id, width: 200, height: 200, zoom: row[:zoom].to_f, crop: :thumb, gravity: :face, radius: :max, format: "png")
      end
    end
  end
  sorted_rows = sorted_rows.reject{|x| x[:remote_cropped_image_url].blank?}
  sorted_rows
end


def ensure_local_faculty_face_images!(sorted_rows)
  base_uri = "https://bair-dev.firebaseio.com"
  cli = Firebase::Client.new(base_uri)
  cli_key = "local_faculty_processed_images_v2"
  processed_images = cli.get(cli_key).body || {}
  processed_keys = processed_images.keys
  todo_images = sorted_rows.map{|x| [x[:remote_cropped_image_url], x]}.reject{|x| processed_keys.include?(Digest::MD5.hexdigest(x[0]))}

  Cloudinary.config do |config|
    config.cloud_name = ENV["CLOUDINARY_CLOUD_NAME"]
    config.api_key = ENV["CLOUDINARY_API_KEY"]
    config.api_secret = ENV["CLOUDINARY_API_SECRET"]
  end

  todo_images.each do |image_url, content|
    STDERR.puts "Processing #{image_url}..."
    STDERR.puts "Downloading image..."
    begin
      file_name = Digest::MD5.hexdigest(image_url) + ".png"
      open("#{FACULTY_CLOUDINARY_CACHE_PATH}/#{file_name}", 'wb') do |file|
        file << open(image_url).read
      end
      processed_images = cli.get(cli_key).body || {}
      processed_images[Digest::MD5.hexdigest(image_url)] = file_name
      # save after every update
      cli.set(cli_key, processed_images)
    rescue Exception => e
      STDERR.puts e
      STDERR.puts content
      STDERR.puts "Continuing"
    end
  end
  sorted_rows.each do |row|
    unless row[:remote_cropped_image_url].blank?
      key = Digest::MD5.hexdigest(row[:remote_cropped_image_url])
      if processed_images.include?(key)
        row[:cropped_image_url] = "#{FACULTY_WEB_CLOUDINARY_CACHE_PATH}/#{key}.png"
      end
    end
  end
  sorted_rows = sorted_rows.reject{|x| x[:cropped_image_url].blank?}
  sorted_rows
end
