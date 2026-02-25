require 'date'
Encoding.default_external = 'UTF-8'

text = "";

fileinput = ARGV[0]
starttime_str = ARGV[1]
finishtime_str = ARGV[2]
fileoutput = ARGV[3]    

starttime = Date.strptime(starttime_str, "%d.%m.%Y")
finishtime = Date.strptime(finishtime_str, "%d.%m.%Y")



countMaxMatches = 0
countMatchDays = 0
daysOfTournament = []

i = starttime
while i < finishtime
      if i.wday == 0 || i.wday == 5 || i.wday == 6
                countMatchDays += 1
                daysOfTournament << i
      end
      i += 1
end
countMaxMatches = countMatchDays * 6
puts countMaxMatches

team_names = []
File.foreach(fileinput) do |line|
  name = line.strip.split('—').first.strip.gsub(/^\d+\.\s*/, '')
  team_names << name
end

teamInvolvement = {}
team_names.each do |name|
  teamInvolvement[name] = 0
end



days_info = []
daysOfTournament.each do |_day|
  time = Time.new(_day.year, _day.month, _day.day, 12)
  days_info += [[time, 0]]

end
puts daysOfTournament



i_day = 0
currentMatches = 0
while currentMatches < countMaxMatches
  opp1 = team_names[rand(team_names.length)]
  begin
    random_index = rand(team_names.length)
  end while team_names[random_index] == opp1
  opp2 = team_names[random_index]
  

  day = days_info[i_day]

  day[1] += 1
  if day[1] > 2
    d = day[0] 
    if d.hour >= 18
      i_day += 1
    else
      day[0] = Time.new(d.year, d.month, d.day, d.hour + 3)
    end
    
    day[1] = 1
  end
  text += "##{currentMatches}<| #{day}, #{opp1}, #{opp2} |\n> "
  teamInvolvement[opp1] += 1
  teamInvolvement[opp2] += 1

  
  currentMatches += 1
  if i_day >= days_info.length()-1
    i_day = 0
  else
    i_day += 1
  end


end
puts text
def parse_and_format_calendar(input_string)
  
  matches_data = input_string.split(/(?=#\d+<\|)/).reject(&:empty?)
  
  parsed_matches = []
  
  matches_data.each do |match_str|
    # Извлекаем номер матча, дату, команды
    if match_str =~ /#(\d+)<\| \[(.*?),\s*\d+\],\s*(.*?),\s*(.*?)\s*\|/
      match_num = $1.to_i
      datetime_str = $2
      team1 = $3.strip
      team2 = $4.strip
      
      begin
        datetime = DateTime.parse(datetime_str)
        parsed_matches << {
          number: match_num,
          datetime: datetime,
          team1: team1,
          team2: team2
        }
      rescue => e
        puts "Ошибка парсинга даты: #{datetime_str}"
      end
    end
  end
  
  sorted_matches = parsed_matches.sort_by { |m| m[:datetime] }
  
  grouped_by_date = sorted_matches.group_by { |m| m[:datetime].to_date }
  
  days_ru = {
    0 => 'воскресенье', 1 => 'понедельник', 2 => 'вторник',
    3 => 'среда', 4 => 'четверг', 5 => 'пятница', 6 => 'суббота'
  }
  
  output = "СПОРТИВНЫЙ КАЛЕНДАРЬ\n"
  output += "=" * 60 + "\n\n"
  
  grouped_by_date.sort.each do |date, games|
    date_str = date.strftime('%d.%m.%Y')
    day_str = days_ru[date.wday]
    output += "#{date_str} (#{day_str})\n"
    output += "-" * 40 + "\n"
    
    games.sort_by { |g| g[:datetime] }.each do |game|
      time_str = game[:datetime].strftime('%H:%M')
      output += "  #{time_str}  |  #{game[:team1]}  vs  #{game[:team2]}\n"
    end
    output += "\n"
  end
  
  output += "=" * 60 + "\n"
  output += "Всего игр: #{sorted_matches.size}\n"
  output += "Игровых дней: #{grouped_by_date.size}\n"
  
  output
end

text = parse_and_format_calendar(text)
File.write(fileoutput, text)
#puts text
puts teamInvolvement