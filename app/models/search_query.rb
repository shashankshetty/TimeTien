class SearchQuery
  attr_reader :options, :user
  attr_accessor :tasks, :search_type, :summary

  def validate_start_time_earlier_than_end_time
    if (start_time && end_time && start_time > end_time)
      return "end time cannot be earlier than start time"
    end
  end

  def initialize(options, user)
    @options = options || {}
    @user = user
  end

  def analyze
    @options[:analyze]
  end

  def projects
    @options[:search_project]
  end

  def tags
    @options[:search_tag]
  end

  def user_id
    user.id
  end

  def start_time
    parse_datetime(@options[:start_time])
  end

  def end_time
    parse_datetime(@options[:end_time])
  end

  def has_projects?
    projects.present?
  end

  def has_tags?
    tags.present?
  end

  def has_user?
    user_id.present?
  end

  def has_start_time?
    start_time.present?
  end

  def has_end_time?
    end_time.present?
  end

  def conditions
    conditions = []
    parameters = []

    return nil if options.empty?

    if has_user? && analyze == 'task'
      conditions << "user_id = ?"
      parameters << "#{user_id}"
    end

    if has_tags?
      conditions << "tag_id in (#{tags.collect { |c| c }.join(',')})"
    end

    if has_start_time?
      conditions << "start_time >= ?"
      parameters << "#{start_time}"
    end

    if has_end_time?
      conditions << "(end_time <= ? or end_time is null)"
      parameters << "#{end_time}"
    end

    unless conditions.empty?
      [conditions.join(" AND "), *parameters]
    else
      nil
    end
  end

  def get_tags_for_projects
    return Tag.find(:all, :conditions => "project_id in (#{projects.collect { |c| c }.join(',')})").collect { |x| [x.name, x.id.to_s] } if has_projects?
    []
  end

  private

  def parse_datetime(t)
    return t if t.nil?
    Chronic.parse(t)
  end
end