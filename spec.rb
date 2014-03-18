assert Configuration.files.type? == array
assert Configuration.files.each.File.exist?
assert Configuration.behavior == "Filter" || Config.behavior == "Match"
