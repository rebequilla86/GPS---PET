class RoutePolicy
	attr_reader :user, :route

	def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
  	auth_default
  end

  def show?
  	auth_default or user.walker?
  end

  def edit?
  	auth_default
  end

  def create?
  	auth_default
  end

  def update?
  	auth_default
  end

  def destroy?
    return false if user == record
    user.admin?
  end

  Scope = Struct.new(:user, :scope) do
  	def resolve
  		user.admin? ? scope.all : scope.where(id: user.pets)
  	end
  end

  private

  def auth_default
  	user.admin? || user
  end
end