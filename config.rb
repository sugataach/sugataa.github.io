###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

set :fonts_dir, 'fonts'
set :css_dir, 'stylesheets'
set :images_dir, 'images'
set :js_dir, 'javascripts'

set :relative_links, true

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"
  blog.permalink = '{title}'
  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "articles/{year}-{month}-{day}-{title}"
  # blog.taglink = "tags/{tag}.html"
  blog.layout = "article_layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.branch = 'master'
  deploy.build_before = true
end

activate :directory_indexes

activate :syntax, line_numbers: true
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

page "/feed.xml", layout: false
# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
helpers do
  def strip_summary(html)
    html.gsub(/<h1>.+<\/h1>/, "")
  end

  # Builds a page title from the article title + site title
  def page_title
    if current_article && current_article.title
      current_article.title + ' | ' + config[:site_title]
    else
      config[:site_title]
    end
  end

  # Renders component partials
  def component(path, locals = {})
    partial "components/#{path}", locals
  end
end

set :url_root, "'https://sugataa.github.io ? https://sugataa.github.io : 'localhost:4567'}"

activate :search_engine_sitemap,
         exclude_if: -> (resource) {
           # Exclude all paths from sitemap that are sub-date indexes
           resource.path.match(/[0-9]{4}(\/[0-9]{2})*.html/)
         },
         default_change_frequency: 'weekly'

# Build-specific configuration
configure :build do
  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  activate :gzip
  # Use relative URLs
  # activate :relative_assets

  activate :minify_html do |html|
    html.remove_http_protocol = false
  end
end
