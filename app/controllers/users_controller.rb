class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in ,except: %i[main findbyemail]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to user_delview_path(@user), notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delview
    uid = params[:id]
    u = User.find(uid)
    @name = u.name
    @email = u.email
    @birthdate = u.birthdate
    @address = u.address
    @postal_code = u.postal_code
    u.destroy
  end

  def create_fast
    names = params[:name]
    email = params[:email]
    User.create(name:names,email:email,birthdate:0,address:0,postal_code:0)

    respond_to do |format|
      format.html { redirect_to users_path(@user), notice: "User was successfully created again." }
      format.json { head :no_content }
    end


  end

  def main
    session[:user_id] = nil
  end

  def findbyemail
    emails = params[:email]
    password = params[:password]
    @user = User.find_by(email:emails)
    if (!@user.nil?)
      if (@user.authenticate(password))
        session[:user_id] = @user.id
        respond_to do |format|
          format.html { redirect_to showforuserlogin_path(@user.id) }
          format.json { head :no_content }
        end
      else
        session[:user_id] = nil
        respond_to do |format|
          format.html { redirect_to main_path, notice: "Wrong password" }
          format.json { head :no_content }
        end
      end
    else
      session[:user_id] = nil
      respond_to do |format|
        format.html { redirect_to main_path, notice: "Wrong email " }
        format.json { head :no_content }
      end
    end
  end

  def showforuserlogin
    if (logged_in)
      uid = params[:id]
      @user = User.find(uid)
    else
      return 
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :birthdate , :address,:postal_code ,:password)
    end

    def logged_in
      if (session[:user_id])
        return true
      else
        respond_to do |format|
          format.html { redirect_to main_path, notice: "Please Login " }
          format.json { head :no_content }
        end
      end
    end

end


