require 'oj'
require 'pry'
data = Oj.load_file 'AllSets-x.json'
new_data = {}

data.each do |code, set|
  cards = set["cards"]
  cards.each do |c|
    if c.has_key? "foreignNames"
      if kname = c["foreignNames"].find{|x| x["language"] == "Korean"}
        next unless kname["multiverseid"]
        new_data[kname["name"]] = kname["multiverseid"]
      end
    end
  end
end
binding.pry
File.write "korean.json", Oj.dump(new_data)
# ["SOI"]["cards"].map{|x| x["foreignNames"]}
