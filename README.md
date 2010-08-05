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

### API

TODO: add examples (extracted from ArchiveTree::ClassMethods)

### Views


## Documentation

This gem's documentation documentation is available at http://yardoc.org/docs/GnomesLab-archive_tree


## License

Copyright (c) 2010 Diogo Almeida, released under the MIT license. For more information regarding MIT license, please check our [MIT license file](http://github.com/GnomesLab/archive_tree/blob/master/MIT-LICENSE)


## Feedback, issues and contributions

If you have an issue with ArchiveTree please create a ticket in our [issue tracker](http://gnomeslab.lighthouseapp.com/projects/57307-archive_tree/overview).

Feel free to fork this project at any time and submit your changes (along with their respective tests).

Should you just wish to provide feedback or say hi, you can always contact us directly through diogo (dot) almeida (at) gnomeslab (dot) com