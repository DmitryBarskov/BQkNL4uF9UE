class DashboardController < ApplicationController
  def index
    @tasks = (1..5).index_with do |task_no|
      send(:"task#{task_no}")
    end
  end

  private

  # Calculate the number of feedbacks of branch `Branch REWE 05`.
  def task1
    branch = Branch.find_by!(name: "Branch REWE 05")
    feedbacks_count = branch.feedbacks.count
    { count: feedbacks_count }
  end

  # Determine the frequency distribution of organization `FitX` w.r.t. `quality`.
  def task2
    org = Organization.find_by!(name: "FitX")
    distribution = Feedback.with_org(org)
      .group(:quality)
      .count
    { distribution: }
  end

  # Determine a cross table for `Douglas` w.r.t. `age group` and `quality` where entries are numbers of feedbacks.
  def task3
    org = Organization.find_by!(name: "Douglas")
    feedbacks = Feedback.with_org(org).group(:age_group, :quality).count
    age_group_to_quality_to_count = {}
    feedbacks.each do |key, count|
      age_group_to_quality_to_count[key[0]] ||= {}
      age_group_to_quality_to_count[key[0]][key[1]] = count
    end
    add_rows_and_columns(table: age_group_to_quality_to_count)
  end

  # Determine a ranking for all branches of `BMW` w.r.t. average of `quality`.
  def task4
    org = Organization.find_by!(name: "BMW")
    branch_with_score = org.branches
      .joins(:feedbacks)
      .group("branches.name")
      .select("branches.name", "AVG(feedbacks.quality) AS score")
      .order(score: :desc)
    { list: branch_with_score }
  end

  # Calculate all net promoter scores* for all organizations and display them in a table.
  def task5
    list = Organization.joins(branches: :feedbacks)
      .group("organizations.name")
      .select(
        <<~SQL.squish
          organizations.id,
          organizations.name AS name,
          (SUM(case when nps <= 6 then 1 else 0 end) - SUM(case when nps >= 9 then 1 else 0 end)) / CAST(COUNT(1) AS FLOAT) AS nps
        SQL
      )
    { list: list.map(&:attributes) }
  end

  def add_rows_and_columns(table:)
    {
      table:,
      rows: table.keys,
      columns: table.values.flat_map(&:keys).uniq
    }
  end
end
