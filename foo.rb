require 'yaml'

#change_set = [
#  'terraform/levels/1/foo.tf',
#  'terraform/levels/1/bar.tf',
#  'README.md',
#]

change_set = YAML.load_file(ARGV[0])
puts "change_set = #{change_set}"

project_map = YAML.load_file('project_map.yaml')
puts "project_map = #{project_map}"

Array tf_files = []
for i in 0..(change_set.size - 1) do
  if change_set[i] =~ /\.tf$/
    tf_files << File.dirname(change_set[i])
  end
end
puts "tf_files = #{tf_files}"
uniq_dirs = tf_files.uniq
if uniq_dirs.size != 1
  puts "ERROR: multiple matches"
  puts "uniq_dirs = #{uniq_dirs}"
  exit 1
end
dir = uniq_dirs[0]
puts "dir = #{dir}"

Array tf = []
project_map.find { |k,v|
  if v == dir
#    puts "MATCH - dir = #{dir} :: k = #{k} :: v = #{v} :: v.size = #{v.size}"
    tf << k
    tf << v
  else
#    puts "NO MATCH - dir = #{dir} :: k = #{k} :: v = #{v} :: v.size = #{v.size}"
  end
}

#puts "tf = #{tf}"
if tf.size < 2
  puts "ERROR: no match"
else
  tf_level = tf[0]
  tf_path = tf[1]
  puts "tf_level = #{tf_level}"
  puts "tf_path = #{tf_path}"
end
