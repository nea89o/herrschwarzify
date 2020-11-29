require 'sinatra'
require 'chunky_png'
require 'rmagick'

COORDS = 225, 1300
SIGN_SIZE = 1443, 900
IMAGE_SIZE = 1920, 2218
OVERLAY = Magick::ImageList.new("herrschwarz.png")

def random_file_name(ext)
  (0...50).map { ('a'..'z').to_a[rand(26)] }.join + "." + ext
end

def herrschwarzify_image(image)
  background = Magick::Image.new(*IMAGE_SIZE)
  canvas = Magick::Draw.new
  canvas.composite *COORDS, *SIGN_SIZE, image
  canvas.composite 0, 0, 0, 0, OVERLAY
  canvas.draw background
  background
end

Dir.mkdir "uploads" unless Dir.exists? "uploads"

get "/" do
  erb :index
end

post "/upload" do
  return redirect "/" unless params['file'] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
  orig = Magick::ImageList.new(tmpfile.path)
  transformed = herrschwarzify_image(orig)
  filename = random_file_name("png")
  transformed.write("uploads/#{filename}")
  redirect "/uploads/#{filename}"
end

get "/uploads/:filename" do |filename|
  send_file "uploads/#{filename}", :type => :png
end
