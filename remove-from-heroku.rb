#
# Script used to remove a specific user from all known
# Heroku apps.
#

SUBJECT = "email@crowdint.com"
FILE    = "apps.txt"

`heroku apps > #{FILE}`

def is_an_app_name?(name)
  !(name.match(/=/) || name.empty?)
end

File.open(FILE).each(sep="\n") do |l|
  if is_an_app_name?(l)
    result = l.match(/[\w\-]+/)
    if result
      app = result[0]
      p "Trying our luck on #{app}..."
      `heroku info --app #{app} > info.txt`

      subject = File.open("info.txt").grep(%r{#{SUBJECT}})

      unless subject.empty?
        p "Removing #{SUBJECT} from #{app}"
        `heroku sharing:remove #{SUBJECT} --app #{app}`
      end
    end
  end
end

