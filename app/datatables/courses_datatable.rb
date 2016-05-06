class CoursesDatatable
  include AjaxDatatablesRails::Extensions::Kaminari

  delegate :params, :link_to, to: :@view

  def initialize view
    @view = view
  end

  def as_json options = {}
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Course.count,
      iTotalDisplayRecords: courses.total_count,
      aaData: data
    }
  end

  private
  def data
    courses.each_with_index.map do |course, index|
      [
        index + 1,
        link_to(course.name, @view.admin_course_path(course)),
        course.load_trainers.map do |trainer|
          link_to(@view.avatar_user_tag(trainer, "profile-user",
          Settings.image_trainer_size), @view.user_path(trainer),
          title: trainer.name)
        end,
        course.load_trainees.map do |trainee|
          link_to(@view.avatar_user_tag(trainee, "profile-user",
          Settings.image_trainee_size), @view.user_path(trainee),
          title: trainee.name)
        end,
        course.status
      ]
    end
  end

  def courses
    @courses ||= fetch_courses
  end

  def fetch_courses
    courses = Course.order("#{sort_column} #{sort_direction}")
      .where("name like :search", search: "%#{params[:sSearch]}%")
      .per_page_kaminari(page).per per_page

    if params[:sSearch_4].present?
      courses = courses.where "status = :search", search: "#{params[:sSearch_4]}"
    end
    courses
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name]
    columns[params[:iSortCol_1].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
