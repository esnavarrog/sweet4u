class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update]
  def show
    @profile = Profile.find_by(user_id: params[:id]) # o como identifiques el perfil
    if @profile.nil?
      flash[:alert] = "Perfil no encontrado"
      redirect_to root_path # o donde quieras redirigir
    end
  end

  def index
  end

  def edit
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profile_path(@profile.user_id), notice: "Perfil actualizado con éxito" }
        format.json { render json: { message: "Perfil actualizado con éxito" }, status: :ok }
        format.js   { render :update }
      else
        format.html { render :edit, alert: "Error al actualizar el perfil" }
        format.json { render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity }
        format.js   { render :edit }
      end
    end
  end

  def delete_image_profile
    @profile = current_user.profile
    image_number = params[:image_number].to_i
    image_key = "image#{image_number}".to_sym
    @profile.update_column(image_key, nil)
  end

  private

  def set_profile
    @profile = Profile.find_by(user_id: params[:id])
  end

  def profile_params
    params.require(:profile).permit(
      :bio, :birthdate, :gender, :sexual_orientation, :location, :looking_for,
      :relationship_type, :is_visible, :height, :body_type, :ethnicity, :education,
      :occupation, :religion, :political_views, :age_range, :distance_range,
      :image1, :image2, :image3, :image4, :image5, :image6, :avatar_image,
      interests: []
    )
  end
end
