class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @total_guesses = 0
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    #which retrieves a random word from a Web service
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  #attr_accessor :word, :guesses, :wrong_guesses
  def guessbrian(guess)
      #error checking
      if guess == nil || guess == "" || guess =='%'
         throw :guess
      end
      #initialize variables and split
      guess = guess.downcase
      flag = 0
      splitWord = @word
      splitWord = splitWord.downcase.split("")
      #check and assign
      splitWord.each { |x|
      if x == guess
        flag = 1
      end
      }
      if flag == 1
       if @guesses == guess
         return false
       else
         @guesses << guess
         return true
       end
      else
        if guess == guess.gsub(/[^A-Za-z]/, '') && guess != @wrong_guesses
          @wrong_guesses << guess
          return true
        else
          return false
        end
      end
  end #end of brians fucntion

  def is_repeated?(test)
    flag = false
    @guesses == test || @wrong_guesses == test ? flag = true : flag = false
    #puts "@guesses == test || @wrong_guesses == test #{@guesses == test || @wrong_guesses == test}"

    if flag
      return flag
    else
      #puts @word
      word = @word.split("")
      #puts word
      guessChar = @guesses.split("")
      word.each { |x|
          if word.include?(guessChar)
            flag = true
            return flag
          end
      }

    end
    return flag
  end

  def check_win_or_lose
    #which returns one of the symbols :win, :lose, or :play depending on the current game state
    if @total_guesses == 7
      return :lose
    elsif @word == word_with_guesses()
      return :win
    else
      return :play
    end
  end

  attr_accessor :word, :guesses, :wrong_guesses
  def guess(test_guess)

    #condition ? if_true : if_false
    previousGuesses = @guesses.split('')

    #which processes a guess and modifies the instance variables wrong_guesses and guesses accordingly
    puts "++++++++RECEIVING:#{test_guess} word=#{@word}"

    #if is invalidlanzar exepcion
    if test_guess == nil || test_guess == '' || test_guess == '%'
      throw :guess
    else
      #continua
      test_guess = test_guess.downcase

      #si esta repetida
      if is_repeated?(test_guess)
        return false
      end

      #partimos test_guess y word en tokens
      test_guess = test_guess.split('')
      word = @word.split('')
      flag = false
      test_guess.each do |letter|

        if previousGuesses.include?(letter)
          return false
        end

        @total_guesses = @total_guesses + 1
        #for only 1 letter received
        if test_guess.size == 1
          if !word.include?(letter)
            @wrong_guesses = @wrong_guesses + letter
            return true
          end
        end


        if word.include?(letter)
          #guess was correct
          @guesses = @guesses + letter
          flag = true
        else
          #guess was incorrec
          @wrong_guesses = @wrong_guesses + letter
          #puts "#{word} NOT includes #{letter}"
          #puts "wrong_guesses #{@wrong_guesses}"
          flag = true
        end

      end #end of do |letter|
      return flag
    end

  end #end of function

  def word_with_guesses()
    #puts @word
    word = @word.split("")
    #puts word
    guessChar = @guesses.split("")
    #puts "guesses #{guessChar}"
    displayed = ""
    #displayed = word.gsub(/[^A-Za-z]/, '-')


    word.each { |x|
        #puts "WORD_GUESSES_FOR?(#{x}) #{guesses_include_in?(x)}"
        if guesses_include_in?(x)
          displayed = displayed + x
        else
          displayed = displayed + "-"
        end
    }
    #puts "displayed #{displayed}"
    return displayed
  end #end of word with guesses

  def guesses_include_in?(letter)
    #puts @word
    word = @word.split("")
    guessChar = @guesses.split("")
    #puts "***guesses_include_in? #{word} #{guessChar}"
    word.each do |w|
      guessChar.each do |g|
        #puts "w == g && g == letter"
        #puts "#{w} == #{g} && #{g} == #{letter} ==> #{w == g && g == letter}"
        if w == g && g == letter
          return true
        else
          #return false
        end
      end

    end
  return false
end #end of function

def is_letter_repeated?(letter)
  flag = false
  @guesses == letter || @wrong_guesses == letter ? flag = true : flag = false
  puts "@guesses == letter || @wrong_guesses == letter #{@guesses == letter || @wrong_guesses == letter}"

  if flag
    return flag
  else
    word = @wrong_guesses.split("")
    guessChar = @guesses.split("")
    #puts "***guesses_include_in? #{word} #{guessChar}"
    word.each do |w|
      guessChar.each do |g|
        #puts "w == g && g == letter"
        puts "#{w} == #{g} && #{g} == #{letter} ==> #{w == g && g == letter}"
        if w == g && g == letter
          return true
        end
      end
    end
  return false
end
  end #end of function

end

=begin
game = HangpersonGame.new('banana')


puts game.is_letter_repeated?('a')
puts game.guess('a')
puts game.guesses
puts game.wrong_guesses
puts game.is_letter_repeated?('a')

puts "===game gueses==="
puts game.guess('z')
puts game.guesses
puts game.wrong_guesses
puts "===game gueses==="
puts game.guess('aq')
puts game.guesses
puts game.wrong_guesses
puts 'game repeated'
puts game.guess('a')
puts game.guess('q')
game.guesses = 'bn'
puts game.word_with_guesses

=end
