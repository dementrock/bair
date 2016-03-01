require 'redcarpet'

def get_qna
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  content = open(File.dirname(__FILE__) + "/getting_involved.md").read
  markdown.render(content)
end
