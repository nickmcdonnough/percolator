module Percolator
  class Hamming < TXS
    def run a, b
      x, y = a.downcase, b.downcase
      counter, diff = 0, 0
      length = [x.size, y.size].min

      until counter == length
        if x[counter] != y[counter]
          diff += 1
        end
        counter += 1
      end

      diff
    end
  end
end
