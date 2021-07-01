require "sinatra"
require "pry"
require "uri"
require "fileutils"

INPUT = "./images_in/"
KEEPERS = "./images_selected/"
REJECTS = "./images_rejected/"
GRID_SIZE = 78

set :public_folder, INPUT

get "/" do
  params.map do |(str, state)|
    fname = URI.decode_www_form_component(str)
    if state == "KEEP"
      FileUtils.mv(INPUT + fname, KEEPERS + fname)
    else
      FileUtils.mv(INPUT + fname, REJECTS + fname)
    end
  end
  @images = Dir
    .children(INPUT)
    .sample(GRID_SIZE)
    .reject { |f| f == ".gitkeep" }
    .map { |s| URI.encode_www_form_component(s) }
  erb :index, layout: :layout
end
