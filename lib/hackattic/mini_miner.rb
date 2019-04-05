module Hackattic
  # Mini miner
  class MiniMiner
    attr_reader :block, :difficulty

    def initialize(block:, difficulty:)
      @block      = block
      @difficulty = difficulty
    end

    def call
      solution, tries, time = mine
      puts "Solution found after #{time.round}s and #{tries} tries."
      { nonce: solution }
    end

    private

    def mine
      tries = 0
      time_start = Time.now
      seed = Random.new.rand(2**difficulty - 1)
      loop do
        solution = calculate_solution(seed)

        return [seed, tries, Time.now - time_start] if check(solution)

        tries += 1
        seed += 1
      end
    end

    def check(solution)
      # Digits to check.
      bin_number = split_digits(solution).each_with_object('') do |digit, obj|
        # Converting each digit individually to binary in descending order,
        # ensuring extra zeros if needed.
        obj << digit.hex.to_s(2).rjust(4, '0')
      end
      puts "#{bin_number.gsub('0', '0'.yellow.bold)} (D: #{difficulty}, S: #{solution})"
      bin_number.start_with?('0' * difficulty)
    end

    def calculate_solution(seed)
      block = self.block.merge(nonce: seed).sort_by { |k, _| k }.to_h
      body = Oj.dump(block, mode: :compat)
      Digest::SHA256.hexdigest(body)
    end

    def checking_digits
      difficulty.fdiv(4).ceil
    end

    def split_digits(solution)
      solution[0..checking_digits - 1].split('')
    end
  end
end
