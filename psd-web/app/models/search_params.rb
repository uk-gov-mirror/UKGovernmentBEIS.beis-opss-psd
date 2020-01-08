# This model is just a convenience wrapper for the relevant search query params, for use with FormHelper in the view.
class SearchParams
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :q
  attribute :sort
  attribute :direction
  attribute :status_closed
  attribute :assigned_to_someone_else_id
  attribute :created_by_someone_else_id

  attribute :status_open,               :string, default: "checked"
  attribute :sort_by,                   :string, default: "recent"
  attribute :assigned_to_me,            :string, default: "unchecked"
  attribute :assigned_to_someone_else,  :string, default: "unchecked"
  attribute :created_by_me,             :string, default: "unchecked"
  attribute :created_by_someone_else,   :string, default: "unchecked"
  attribute :allegation,                :string, default: "unchecked"
  attribute :enquiry,                   :string, default: "unchecked"
  attribute :project,                   :string, default: "unchecked"
end
