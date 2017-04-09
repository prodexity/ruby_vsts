# ruby_vsts
An unofficial Microsoft Visual Studio Team Services (VSTS) API client in Ruby

[![Code Climate](https://codeclimate.com/github/prodexity/ruby_vsts.png)](https://codeclimate.com/github/prodexity/ruby_vsts)
[![Issue Count](https://codeclimate.com/github/prodexity/ruby_vsts/badges/issue_count.svg)](https://codeclimate.com/github/prodexity/ruby_vsts)
[![Test Coverage](https://codeclimate.com/github/prodexity/ruby_vsts/badges/coverage.svg)](https://codeclimate.com/github/prodexity/ruby_vsts/coverage)

# About
This will be a Ruby gem to connect to the Microsoft Visual Studio online (VSTS) Rest API.
It may also work with recent versions of TFS too. *Work is heavily in progress!*

# Usage
```ruby
require 'ruby_vsts'

VSTS.configure do |config|
  config.personal_access_token = "YOUR_PERSONAL_ACCESS_TOKEN"
  config.base_url = "https://YOUR_INSTANCE.visualstudio.com/"
end

VSTS::Changeset.find(72300)
# ...
```

See the source code for further examples until I find the time to add docs. Sorry. :)
