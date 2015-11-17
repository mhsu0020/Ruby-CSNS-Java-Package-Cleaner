
require 'fileutils'
time = Time.new
current_folder_name = File.basename(Dir.getwd)
path_for_modified_files = "#{File.expand_path('..')}/#{current_folder_name}Modified#{time.year}#{time.month}#{time.day}#{time.hour}#{time.min}#{time.sec}"
FileUtils.mkdir_p path_for_modified_files
FileUtils.cp_r '.', path_for_modified_files
FileUtils.cd(path_for_modified_files)
FileUtils.rm("CSNSPackageUpdater.rb")
Dir.foreach(path_for_modified_files) do |item|
  next if item == '.' or item == '..'
  new_directory_name = item.sub('.', '').sub(' ','').sub('-', '')
  files_to_add_package_statement = []
  Dir.foreach(item) do |file|
    next if file == '.' or file == '..'
    files_to_add_package_statement<< "#{new_directory_name}/#{file}"
  end
  #puts files_to_add_package_statement.inspect
  File.rename item, new_directory_name
  files_to_add_package_statement.each do |original_file|
      new_file = original_file + '.new'
      File.open(new_file, 'w') do |fo|
        fo.puts "package #{new_directory_name};"
      File.foreach(original_file) do |li|
        next if li.start_with?('package')
        fo.puts li
      end
    end
  File.rename(original_file, original_file + '.old')
  File.rename(new_file, original_file)
  FileUtils.rm(original_file + '.old')
  end
end
