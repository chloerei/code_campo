# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

site = Site.new

site.fragment.footer = <<-EOF
<div class="pull-left">
  <p>CodeCampo is a small community for web develeper and open source in <a href="https://github.com/chloerei/code_campo">Github</a> by <a href="https://twitter.com/chloerei">@chloerei</a>.</p>
  <p>Feel free to use source code under MIT license.</p>
</div>
<div class="pull-right">
  <p><a href="#top">Back to top</a></p>
</div>
EOF

site.fragment.home_sidebar_bottom = <<-EOF
<section class="box">
  <header>Power by</header>
  <a href="http://rubyonrails.org"><img src="/assets/rails.png" /></a>
</section>
EOF

site.save
