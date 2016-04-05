class Admin::CourseSubjectsController < ApplicationController
  load_and_authorize_resource
  before_action :load_course, only: [:index, :show, :edit]

  def index
    @course_subjects = @course.course_subjects
  end

  def edit
  end

  def update
    if @course_subject.update_attributes course_subject_params
      flash[:success] = flash_message "updated"
      redirect_to admin_course_course_subjects_path
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  private
  def course_subject_params
    params.require(:course_subject).permit CourseSubject::ATTRIBUTES_PARAMS 
  end

  def load_course
    @course = Course.find params[:course_id] 
  end
end
