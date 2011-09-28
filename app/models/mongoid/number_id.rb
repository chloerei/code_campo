module Mongoid
  module NumberId
    extend ActiveSupport::Concern

    included do
      field :number_id,  :type => Integer
      index :number_id,  :unique => true

      before_create :set_number_id
    end

    module ClassMethods
      def number(id)
        first :conditions => {:number_id => id}
      end
    end

    module InstanceMethods
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
