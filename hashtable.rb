class MyHashTable

  DEFAULT_BUCKETS = 11
  MAX_ENTRIES = 5

  def initialize
    @buckets = DEFAULT_BUCKETS
    @table = Array.new(@buckets)
  end

  def put(key, value)

    hashed_key = generate_hash(key)

    @table[hashed_key] ||= []
    @table[hashed_key].push([key, value])

    if @table[hashed_key].length > MAX_ENTRIES
      rehash
    end

  end

  def get(requested_key)

    hashed_key = generate_hash(requested_key)

    @table[hashed_key].each do |key, value|
      if key == (requested_key)
        return value
      end
    end

  end

  private

  def generate_hash(input)
    return input.hash % @buckets
  end

  def rehash

    @buckets = @buckets * 2

    old_table = @table

    @table = Array.new(@buckets)

    old_table.each do |bucket|
      if bucket
        bucket.each do |entry|
          put(entry[0], entry[1])
        end
      end
    end

  end

end

require "securerandom"
require "benchmark"

my_hash = MyHashTable.new()

time = Benchmark.realtime do 
  (1...10_000_001).each do |i|
    my_hash.put("#{i}", "foo#{i}")
  end
end

puts my_hash.get("10000")

puts "Generated my hash in #{time * 1000}ms"

%w(1 100000 1000000 10000000).each do |key|

  time = Benchmark.realtime do
    puts my_hash.get(key)
  end

  puts "Finding #{key} took #{time * 1000}ms"

end


puts "Normal ruby"

my_hash = Hash.new()

time = Benchmark.realtime do
  (1...10_000_002).each do |i|
    my_hash[i.to_s] = "foo{#{i}"
  end
end

puts "Generated rubys hash in #{time * 1000}ms"

%w(1 100_000 1_000_000 10_000_000).each do |key|

  time = Benchmark.realtime do
    my_hash[key.to_s]
  end

  puts "Finding #{key} took #{time * 1000}ms"

end
