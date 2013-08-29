module MoveParser
  def convert(move) # "f2 f3" => [[6,5],[5,5]]
    m_a = move.split
    m_a.map! do |pos|
      col = ("a".."h").to_a.index(pos[0])
      [8-pos[1].to_i, col]
    end

    m_a
  end
end
