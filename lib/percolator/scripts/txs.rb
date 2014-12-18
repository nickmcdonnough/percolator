module Percolator
  class TXS
    def self.run inputs
      self.new.run inputs
    end

    def success data={}
      OpenStruct.new data.merge(success?: true)
    end

    def failure error_symbol, data={}
      OpenStruct.new data.merge(error: error_symbol, success?: false)
    end
  end
end
