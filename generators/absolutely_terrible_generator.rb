TEAMS = [
  {
    name: 'Turkey',
    flag: '🇹🇷',
    odds: 61,
    group: 'A',
    tier: 2,
  },
  {
    name: 'Italy',
    flag: '🇮🇹',
    odds: 10,
    group: 'A',
    tier: 1,
  },
  {
    name: 'Wales',
    flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
    odds: 151,
    group: 'A',
    tier: 3,
  },
  {
    name: 'Switzerland',
    flag: '🇨🇭',
    odds: 61,
    group: 'A',
    tier: 2,
  },
  {
    name: 'Denmark',
    flag: '🇩🇰',
    odds: 26,
    group: 'B',
    tier: 2,
  },
  {
    name: 'Finland',
    flag: '🇫🇮',
    odds: 251,
    group: 'B',
    tier: 3,
  },
  {
    name: 'Belgium',
    flag: '🇧🇪',
    odds: 7.0,
    group: 'B',
    tier: 1,
  },
  {
    name: 'Russia',
    flag: '🇷🇺',
    odds: 76,
    group: 'B',
    tier: 2,
  },
  {
    name: 'Netherlands',
    flag: '🇳🇱',
    odds: 11,
    group: 'C',
    tier: 1,
  },
  {
    name: 'Ukraine',
    flag: '🇺🇦',
    odds: 101,
    group: 'C',
    tier: 3,
  },
  {
    name: 'Austria',
    flag: '🇦🇹',
    odds: 91,
    group: 'C',
    tier: 2,
  },
  {
    name: 'North Macedonia',
    flag: '🇲🇰',
    odds: 401,
    group: 'C',
    tier: 3,
  },
  {
    name: 'England',
    flag: '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    odds: 5.5,
    group: 'D',
    tier: 1,
  },
  {
    name: 'Croatia',
    flag: '🇹🇷',
    odds: 26,
    group: 'D',
    tier: 2,
  },
  {
    name: 'Scotland',
    flag: '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
    odds: 201,
    group: 'D',
    tier: 3,
  },
  {
    name: 'Czech Republic',
    flag: '🇨🇿',
    odds: 101,
    group: 'D',
    tier: 3,
  },
  {
    name: 'Spain',
    flag: '🇪🇸',
    odds: 8.0,
    group: 'E',
    tier: 1,
  },
  {
    name: 'Sweden',
    flag: '🇸🇪',
    odds: 76,
    group: 'E',
    tier: 2,
  },
  {
    name: 'Poland',
    flag: '🇵🇱',
    odds: 61,
    group: 'E',
    tier: 2,
  },
  {
    name: 'Slovakia',
    flag: '🇸🇰',
    odds: 251,
    group: 'E',
    tier: 3,
  },
  {
    name: 'Hungary',
    flag: '🇭🇺',
    odds: 251,
    group: 'F',
    tier: 3,
  },
  {
    name: 'Portugal',
    flag: '🇵🇹',
    odds: 8.5,
    group: 'F',
    tier: 1,
  },
  {
    name: 'France',
    flag: '🇫🇷',
    odds: 6.5,
    group: 'F',
    tier: 1,
  },
  {
    name: 'Germany',
    flag: '🇩🇪',
    odds: 8.5,
    group: 'F',
    tier: 1,
  },
]

random = Random.new(1)

players = [
  'Eoin',
  'Peter',
  'Serena',
  'Martin',
  'Waheed',
  'Sean',
  'Dale',
  'Mark',
]

players.shuffle!(random: random)

number_of_combinations = 100000

results = 1.upto(number_of_combinations).map do |i|
  puts "Calculating combination #{i}"

  teams = TEAMS.dup
  res = {}
  success = true

  players.each do |player|
    res[player] = []
    used_groups = []
    
    1.upto(3) do |current_tier|
      teams.shuffle!(random: random)
      available_teams = teams.reject { |t| used_groups.include?(t[:group]) || t[:tier] != current_tier }

      if available_teams.empty?
        success = false
        break
      end

      team = available_teams.pop
      teams.delete(team)
      res[player] << team
      used_groups << team[:group]
    end

    break if success == false
  end

  next nil unless success

  odds = res.map { |_, selected_teams| selected_teams.map { |t| t[:odds] }.inject(:+) }
  odds_diff = odds.sort.last - odds.sort.first

  {
    combination: res,
    odds_diff: odds_diff,
  }
end.compact

puts "Valid combinations: #{((results.count / number_of_combinations) * 100).round}%"

results.sort! { |a, b| a[:odds_diff] <=> b[:odds_diff] }

results.first[:combination].each do |player, selected_teams|
  total_odds = selected_teams.map { |t| t[:odds] }.inject(:+)
  team_names = selected_teams.map { |t| "#{t[:flag]}  #{t[:name]}" }.join(", ")
  puts "#{player}: #{team_names} [Odds weight #{total_odds}]"
end