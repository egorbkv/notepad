# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX

require_relative 'post'
require_relative 'link'
require_relative 'task'
require_relative 'memo'
require 'optparse'


#id, limit, type
options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb[options]'
  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end
  opt.on('--type POST_TYPE', 'Какой тип постов показывать (по умолчанию любой)') { |o| options[:type] = o}
  opt.on('--id POST_ID', 'если задан id - показываем подробно только этот пост') { |o| options[:id] = o}
  opt.on('--limit NUMBER', 'Сколько последних постов показывать (по умолчанию все)') { |o| options[:limit] = o}
end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

if result.is_a? Post
  puts "Запись #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each do |line|
    puts line
  end

else #покажем таблицу
  print "| id\t| @type\t|  @createed_at\t\t\t|  @text \t\t\t|  @url\t\t| @due_date \t"

  result.each do |row|
    puts

    row.each do |element|
      print "| #{element.to_s.delete("\\n\\r")[0..40]}\t"
    end
  end

end