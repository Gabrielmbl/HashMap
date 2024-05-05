class HashMap
  LOAD_FACTOR = 0.7

  def initialize(size = 10)
    @size = size
    @buckets = Array.new(size) { [] }
    @count = 0
  end

  def set(key, value)
    bucket_index = hash(key) % @size
    bucket = @buckets[bucket_index]

    pair_index = bucket.index { |pair| pair.first == key }
    if pair_index
      bucket[pair_index][1] = value
    else
      bucket << [key, value]
      @count += 1
      resize if load_factor >= LOAD_FACTOR
    end
    value
  end

  def get(key)
    bucket_index = hash(key) % @size
    bucket = @buckets[bucket_index]

    pair = bucket.find { |pair| pair.first == key }
    pair ? pair[1] : nil
  end

  def has(key)
    bucket_index = hash(key) % @size
    bucket = @buckets[bucket_index]
    bucket.any? { |pair| pair.first == key }
  end

  def remove(key)
    bucket_index = hash(key) % @size
    bucket = @buckets[bucket_index]

    pair_index = bucket.index { |pair| pair.first == key }
    if pair_index
      entry_to_remove = bucket[pair_index]
      bucket[pair_index] = []
      entry_to_remove
    else
      nil  
    end
  end

  def length
    @count
  end

  def clear
    new_buckets = Array.new(@size) { [] }
    @count = 0
    @buckets = new_buckets
  end

  def keys
    all_keys = []
    @buckets.each do |bucket|
      bucket.each do |key, _|
        all_keys << key
      end
    end
    all_keys
  end

  def values
    all_values = []
    @buckets.each do |bucket|
      bucket.each do |_, value|
        all_values << value
      end
    end
    all_values
  end

  def entries
    all_entries = []
    @buckets.each do |bucket|
      bucket.each do |key, value|
        all_entries << [key,value]
      end
    end
    all_entries
  end

  def load_factor
    @count.to_f / @size
  end

  def resize
    new_size = @size * 2
    new_buckets = Array.new(new_size) { [] }

    @buckets.each do |bucket|
      bucket.each do |key, value|
        new_bucket_index = hash(key) % new_size
        new_buckets[new_bucket_index] << [key, value]
      end
    end

    @size = new_size
    @buckets = new_buckets
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
       
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
       
    hash_code
  end

end