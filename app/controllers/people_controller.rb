class PeopleController < ApplicationController
  before_filter :find_person

  def show
    @topics = @person.topics.order_by([[:created_at, :desc]]).page(1).per(5)
  end

  protected

  def find_person
    @person = User.first :conditions => {:name => /^#{params[:name]}$/i}
    raise Mongoid::Errors::DocumentNotFound.new(User, params[:name]) if @person.nil?
  end
end
