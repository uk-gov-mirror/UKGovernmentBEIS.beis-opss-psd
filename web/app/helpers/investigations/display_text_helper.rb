module Investigations::DisplayTextHelper
  def case_question_text(investigation)
    investigation.is_case ? 'case' : 'question'
  end

  def report_question_text(investigation)
    investigation.is_case ? 'report' : 'question'
  end

  def get_displayable_highlights(highlights)
    highlights.map do |highlight|
      sanitized_content = sanitize(get_highlight_content(highlight), tags: %w(em))
      {
        label: get_highlight_title(highlight),
        content: sanitized_content.html_safe # rubocop:disable Rails/OutputSafety
      }
    end
  end

  def get_highlight_title(highlight)
    field_name = highlight[0]
    replace_unsightly_field_names(field_name).gsub('.', ', ').humanize
  end

  def replace_unsightly_field_names(field_name)
    return "Case id" if field_name == "pretty_id"

    field_name.gsub("search_index", "comment")
  end

  def get_highlight_content(highlight)
    highlighted_texts = highlight[1]
    highlighted_texts.first
  end
end
