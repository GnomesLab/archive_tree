## Introduction

ArchiveTree is a plugin for your Ruby on Rails application that makes it easy for you to generate structured trees of your records.

Since it makes use of your model's _created_at_ column, ArchiveTree is ultimately compatible with most ActiveRecord Models out there.


## Installation

You can install ArchiveTree can be installed as a Ruby gem. This is specially made easy with Bundler. Just add this to your Gemfile

<pre>
gem 'archive_tree'
</pre>

It's also possible to install ArchiveTree as a Rails plugin

<pre>
rails plugin install git://github.com/GnomesLab/archive_tree.git
</pre>


## Examples

Imagine that you have a blog application with Posts. Great!

Now let's say that you wish to allow your users to sweep through your posts in a chronologically accurate tree view. Enters ArchiveTree!

TODO: add examples (extracted from ArchiveTree::ClassMethods)


## Documentation

This gem's documentation documentation is available at http://yardoc.org/docs/GnomesLab-archive_tree


## License
Copyright (c) 2010 Diogo Almeida, released under the MIT license. For more information regarding MIT license, please check our [license file]()
