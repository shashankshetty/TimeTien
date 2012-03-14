module TagsHelper
  def get_hours
    return nil if @tag.time_allocated.blank?
    @tag.time_allocated/60
  end

  def get_minutes
    return nil if @tag.time_allocated.blank?
    return @tag.time_allocated.divmod(60)[1]
  end

  def task_frequencies
    values = {
        '' => 'Select',
        'task' => 'Task',
        'day' => 'Day',
        'week' => 'Week'
    }
    values
  end

  def currencies
    values = {
        'USD' => '$',
        'EUR' => 'EUR',
        'CAD' => 'CAD'
    }
    values
  end

  def time_allocated(tag)
    return nil if tag.time_allocated.blank?
    "#{display_time(tag.time_allocated*60)}/#{tag.frequency}"
  end
end
