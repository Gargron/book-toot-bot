require 'mastodon'
require 'yaml'

config = YAML.load_file(File.join(__dir__, 'config.yml'))
client = Mastodon::REST::Client.new(base_url: config['base_url'], bearer_token: config['token'])
book   = File.read(File.join(__dir__, 'book.txt'))
chunk  = 500

book.gsub!(/[\n\r]+/, ' ')
book.gsub!(/\t/, '')
book.gsub!(/\s{2,}/, ' ')

def next_string(book, chunk, location)
  if (book.size - location) >= chunk
    substring = book[location, chunk]
    length    = chunk
    chapter   = substring =~ /chapter/i

    if chapter && chapter > 1
      return [substring[0, chapter], false]
    else
      if book[location + chunk] != '.'
        while substring[length - 1] != '.'
          length = length - 1

          if length.zero?
            length = chunk
            break
          end
        end

        substring = substring[0, length]
      end

      return [substring, !chapter.nil?]
    end
  else
    [book[location..-1], false]
  end
end

body, new_chapter  = next_string(book, chunk, config['location'])
config['location'] = config['location'] + body.size
status             = client.create_status(body, new_chapter ? nil : config['last_id'])
config['last_id']  = status.id

File.write(File.join(__dir__, 'config.yml'), config.to_yaml)
