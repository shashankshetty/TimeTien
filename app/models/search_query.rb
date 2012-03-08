class SearchQuery
  attr_reader :options, :user
  attr_accessor :tasks, :search_type

  def validate_start_time_earlier_than_end_time
    if (start_time && end_time && start_time > end_time)
      return "end time cannot be earlier than start time"
    end
  end

  def initialize(options, user)
    @options = options || {}
    @user = user
  end

  def tags
    @options[:search_tag]
  end

  def groups
    @options[:search_group]
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

    if has_user?
      conditions << "user_id = ?"
      parameters << "#{user_id}"
    end

    if has_tags?
      conditions << "tag_id in (#{tags.collect{|c| c}.join(',')})"
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

  private

  def parse_datetime(t)
    return t if t.nil?
    Chronic.parse(t)
  end
end