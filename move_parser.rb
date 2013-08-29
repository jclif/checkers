module MoveParser
  def convert(move) # ["f2", "f3"] => [[6,5],[5,5]]
    move.map! do |pos|
      col = ("a".."h").to_a.index(pos[0])
      [8-pos[1].to_i, col]
    end

    move
  end
end
