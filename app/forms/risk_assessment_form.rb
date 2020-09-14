class RiskAssessmentForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  attribute :investigation
  attribute :current_user

  attribute :assessed_on, :govuk_date
  attribute :risk_level
  attribute :custom_risk_level

  attribute :assessed_by
  attribute :assessed_by_team_id
  attribute :assessed_by_business_id
  attribute :assessed_by_other

  attribute :product_ids

  attribute :old_file
  attribute :risk_assessment_file

  attribute :details

  validates :assessed_on, presence: true
  validates :risk_level, presence: true

  validates :risk_assessment_file, presence: true, unless: -> { old_file.present? }

  validates :assessed_by, presence: true
  validate :at_least_one_product_associated

  validates :assessed_by_team_id, presence: true, if: -> { assessed_by == "another_team" }
  validates :assessed_by_business_id, presence: true, if: -> { assessed_by == "business" }
  validates :assessed_by_other, presence: true, if: -> { assessed_by == "other" }

  validates :custom_risk_level, presence: true, if: -> { risk_level.to_s == "other" }

  validates :assessed_on,
            real_date: true,
            complete_date: true

  validate :assessed_on_cannot_be_in_future
  validate :assessed_on_cannot_be_older_than_1970

  def risk_levels
    {
      serious: "serious",
      high: "high",
      medium: "medium",
      low: "low",
      other: "other"
    }
  end

  # Ignore custom risk level value if risk_level isn't other
  def custom_risk_level
    return nil if risk_level.to_s != "other"

    super
  end

  def products
    investigation.products
    .pluck(:name, :id).collect do |row|
      {
        text: row[0],
        value: row[1],
        checked: product_ids.to_a.include?(row[1])
      }
    end
  end

  def other_teams
    [{ text: "", value: "" }] +
      Team
        .order(:name)
        .where.not(id: current_user.team_id)
        .pluck(:name, :id).collect do |row|
          { text: row[0], value: row[1] }
        end
  end

  def businesses
    [{ text: "", value: "" }] + investigation.businesses
      .reorder(:trading_name)
      .pluck(:trading_name, :id).collect do |row|
        { text: row[0], value: row[1] }
      end
  end

  def assessed_by_business_id
    if assessed_by == "business"
      super
    end
  end

  def assessed_by_team_id
    if assessed_by == "my_team"
      current_user.team_id
    elsif assessed_by == "another_team"
      super
    end
  end

  def assessed_by_other
    if assessed_by == "other"
      super
    end
  end

private

  def assessed_on_cannot_be_in_future
    if assessed_on.is_a?(Date) && assessed_on > Time.zone.today

      errors.add(:assessed_on, :in_future)
    end
  end

  def assessed_on_cannot_be_older_than_1970
    if assessed_on.is_a?(Date) && assessed_on < Date.parse("1970-01-01")
      errors.add(:assessed_on, :too_old)
    end
  end

  def at_least_one_product_associated
    return unless product_ids.to_a.empty?

    errors.add(:product_ids, :blank)
  end
end