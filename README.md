## Introduction

ArchiveTree is a Ruby Gem for your Ruby on Rails application that makes it easy for you to generate structured trees of your records.

Since it uses a column of your choice, from any ActiveRecord Model, you will have flexibility to use in most of the Ruby on Rails applications

## Compatibility

The Gem was developed to work with Rails 3.0.x, running on Ruby 1.8.7 or 1.9.2.
Since it uses SQL specific queries, it works on MySQL and PostgreSQL databases.

**Note:** This gem does not work with Ruby v1.9.1.

## Installation

You can install ArchiveTree can be installed as a Ruby gem. This is specially made easy with Bundler. Just add this to your Gemfile

<pre>
gem 'archive_tree'
</pre>

It's also possible to install ArchiveTree as a Rails plugin

<pre>
rails plugin install git://github.com/GnomesLab/archive_tree.git
</pre>


## Demo (live)

If you would like to see this gem in action please visit [Gnomeslab blog](http://gnomeslab.com/blog) at http://gnomeslab.com/blog.

## Examples

Imagine that you have a blog application with Posts. Great!

Now let's say that you wish to allow your users to sweep through your posts in a chronologically accurate tree view. Enters ArchiveTree!

### API

#### Inclusion:

In your ActiveRecord Model:

<pre>
acts_as_archive #=> defaults to :created_at
</pre>

#### Default usage:

<pre>
Post.archive_tree #=> { 2010 => { 1 => [Post], 2 => [Post] },
                        2011 => { 1 => [Post], 4 => [Post], 8 => [Post] } }
</pre>

#### Sweep all months of the current year:

<pre>
Post.archive_tree(:years => [Time.now.year]) #=> { 2010 => { 1 => [Post], 2 => [Post] } }
</pre>

#### Skip all months other than January (1):

<pre>
Post.archive_tree(:months => [1]) #=> { 2010 => { 1 => [Post] },
                                      { 2011 => { 1 => [Post] } } }
</pre>

#### Only sweep January 2010:

<pre>
Post.archive_tree(:years_and_months => { 2010 => [1] }) #=> { 2010 => { 1 => [Post] } }
</pre>

### View

<pre>
draw_archive_tree #=> defaults to: :model_sym => :post, :route => :posts_path, :toggle => true, :toggle_text => '[ + ]'
</pre>

## Documentation

This gem's documentation documentation is available at [rubydoc.info](http://rubydoc.info/github/GnomesLab/archive_tree/master/frames)


## License

Copyright (c) 2010 Diogo Almeida, released under the MIT license. For more information regarding MIT license, please check our [MIT license file](http://github.com/GnomesLab/archive_tree/blob/master/MIT-LICENSE)


## Feedback, issues and contributions

If you have an issue with ArchiveTree please create a ticket in our [issue tracker](http://gnomeslab.lighthouseapp.com/projects/57307-archive_tree/overview).

Feel free to fork this project at any time and submit your changes (along with their respective tests).

Should you just wish to provide feedback or say hi, you can always contact us directly through diogo (dot) almeida (at) gnomeslab (dot) com