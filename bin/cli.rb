require 'CSV'
require_relative '../lib/messages'
require_relative '../lib/finder'
require_relative '../lib/CSV_processor'
require_relative '../lib/cleaner'


class CLI
attr_reader :contents, :command
attr_accessor :finder

  def initialize(instream, outstream)
    @command_entered = ""
    @instream  = instream
    @outstream = outstream
    @filename = "/event_attendees.csv"
    path = File.join(__dir__, @filename)
    @contents =  CSV.read(path, headers: true, header_converters: :symbol)
    @messages = Messages.new
    @finder = Finder.new(@contents)
  end

  def call
    until quit
    print @messages.command_prompt
    @command = gets.strip.downcase
    process_command(@command)
    end
  end

  def load_file(filename="/event_attendees.csv")
    path = File.join(__dir__, filename)
    @contents = CSV.read(path, headers: true, header_converters: :symbol)
  end

  def process_command(command)
    @command = command
    attribute = command.split[1]
    commandlength = -1 + command.length
    case
    when quit
      puts 'quit!'
      exit
    when help
      puts @messages.help
    when help_load
      puts @messages.help_load
    when help_queue
      puts @messages.help_queue
    when help_queue_clear
      puts @messages.help_queue_clear
    when help_queue_print
      puts @messages.help_queue_print
    when help_queue_print_by
      puts @messages.help_queue_print_by
    when help_queue_count
      puts @messages.help_queue_count
    when help_queue_save_to
      puts @messages.help_queue_save_to
    when help_find
      puts @messages.help_find
    when queue_print
      @csv_processor = CSV_processor.new(@finder.queue2).format_output
    when queue_print_by
      attribute = @command.split[3]
      @finder.sorter(attribute)
      @csv_processor = CSV_processor.new(@finder.queue2).format_output
    when find
      criteria = command.split[2..commandlength].join(' ')
      cleaner = Cleaner.new(@contents)
      cleaner.clean_all
      @finder = Finder.new(@contents)
      @finder.lookup(attribute, criteria)
    when queue_count
      @finder.queue_counter
    when queue_clear
      @finder.queue2 = []
    when queue_save_to
      filename = @command.split[3]
      @csv_processor = CSV_processor.new(filename, @finder.queue2)
      @csv_processor.print_to_file
    when load?
      if command.split.length == 2
        filename = attribute
        self.load_file(filename)
      else
        self.load_file
      end
    else
      puts 'invalid command'
    end
  end

  def quit
    @command == 'quit' || @command == 'q'
  end

  def help
    @command == 'help' || @command == 'h'
  end

  def help_load
    @command == 'help load'
  end

  def help_queue
    @command == 'help queue'
  end

  def help_queue_print
    @command == 'help queue print'
  end

  def help_queue_clear
    @command == 'help queue clear'
  end

  def help_queue_print
    @command == 'help queue print'
  end

  def help_queue_print_by
    @command == 'help queue print by'
  end

  def help_queue_count
    @command == 'help queue count'
  end

  def help_queue_save_to
    @command == 'help queue save to'
  end

  def help_find
    @command == 'help find'
  end

  def load?
    @command.split[0] == 'load'
  end

  def find
    @command.split[0] == 'find' || @command.split[0] == 'f'
  end

  def queue
    @first_command== 'queue'
  end

  def queue_count
    @command == 'queue count'
  end

  def queue_print
    @command == 'queue print'
  end

  def queue_print_by
    @command.split[0..2].join(' ') == 'queue print by'
  end

  def queue_save_to
    @command.split[0..2].join(' ') == 'queue save to'
  end

  def queue_clear
    @command == 'queue clear'
  end
end
