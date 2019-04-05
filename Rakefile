task :environment do |_, _args|
  require_relative 'lib/hackattic'
end

desc 'solves a challenge'
task :solve, %i[challenge] => :environment do |_, args|
  Hackattic.solve(args[:challenge]) if args[:challenge]
end
