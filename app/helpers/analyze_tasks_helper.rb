module AnalyzeTasksHelper
  def labels
    @search_query.summary.map {|x| x.name}.join('##')
    end

  def graph_data
    @search_query.summary.map {|x| x.id}.join('##')
  end
end
