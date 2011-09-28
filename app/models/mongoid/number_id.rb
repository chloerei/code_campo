module Mongoid
  module NumberId
    def self.included(base)
      base.class_eval do
        field :number_id,  :type => Integer
        index :number_id,  :unique => true
        scope :number, lambda{|id| where(:number_id => id)}

        before_create :set_number_id

        def set_number_id
          self.number_id = Mongoid.master.collection("counters").find_and_modify({
            :query  => {:_id   => self.class.name},
            :update => {'$inc' => {:next => 1}},
            :new    => true,
            :upsert => true
          })["next"]
        end
      end
    end
  end
end
