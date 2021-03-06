class Finder

  attr_accessor :queue2

  def initialize(contents)
    @queue = []
    @queue2 = []
    @contents = contents
  end

  def lookup(attribute, criteria)
    @queue << @contents.select{|entry| entry[attribute.to_sym] == criteria }
    @queue2 = @queue.flatten
  end

  def queue_counter
    @queue2.count
  end

  def sorter(attribute)
    @queue2 = @queue2.sort{|a,b| a[attribute.to_sym] <=> b[attribute.to_sym]}
  end

end
