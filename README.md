# ruby_vsts
An unofficial Microsoft Visual Studio Team Services (VSTS) API client in Ruby

[![Gem Version](https://badge.fury.io/rb/ruby_vsts.svg)](https://badge.fury.io/rb/ruby_vsts)
[![Code Climate](https://codeclimate.com/github/prodexity/ruby_vsts.png)](https://codeclimate.com/github/prodexity/ruby_vsts)
[![Issue Count](https://codeclimate.com/github/prodexity/ruby_vsts/badges/issue_count.svg)](https://codeclimate.com/github/prodexity/ruby_vsts)
[![Test Coverage](https://codeclimate.com/github/prodexity/ruby_vsts/badges/coverage.svg)](https://codeclimate.com/github/prodexity/ruby_vsts/coverage)

## About
This will be a Ruby gem to connect to the Microsoft Visual Studio online (VSTS) Rest API.
It may also work with recent versions of TFS too. *Work is heavily in progress!*

## Install

### Easy way
```
gem install ruby_vsts
```

### Secure way

Add the public signing key to verify signature:
```
gem cert --add <(curl -Ls https://raw.github.com/prodexity/ruby_vsts/master/certs/ruby_vsts-gem-public_cert.pem)
```

Install with checking signatures:
```
gem install ruby_vsts -P HighSecurity
```

## Usage

### Setup
```ruby
require 'ruby_vsts'

VSTS.configure do |config|
  config.personal_access_token = "YOUR_PERSONAL_ACCESS_TOKEN"
  config.base_url = "https://YOUR_INSTANCE.visualstudio.com/"
end
```

### Finding changesets
```ruby
VSTS::Changeset.find(72300) # find changeset by id
VSTS::Changeset.find_all # find all changesets (paged)
VSTS::Changeset.find_all(author: "fabrikam13@hotmail.com") # find by author
VSTS::Changeset.find_all(fromId: 1000, toId: 1200) # find by id range
VSTS::Changeset.find_all(fromDate: "03-01-2017", toDate: "03-18-2017-2:00PM") # find by date range
VSTS::Changeset.find_all(itemPath: "$/Fabrikam-Fiber-TFVC/Program.cs") # find by item path
VSTS::Changeset.find_all(top: 20, skip: 100) # paging
# ...
```

### Finding shelvesets
```ruby
VSTS::Shelveset.find_all # find all shelvesets (paged)
VSTS::Shelveset.find_all(owner: "fabrikam13@hotmail.com") # find by owner email
VSTS::Shelveset.find_all(owner: "John Doe") # find by owner display name
VSTS::Shelveset.find_all(owner: "11111111-2222-3333-4444-555555555555") # find by owner guid
VSTS::Shelveset.find_all(top: 20, skip: 100) # paging
```

### Getting changes in a changeset (or a shelveset)
```ruby
changeset = VSTS::Changeset.find(72300)
changes = changeset.changes
```

### Getting change items
```ruby
change = changes[0]
item = change.item

file_contents = item.get # downloads current version
path = item.path
url = item.url

# shortcuts:
change.path === item.path
change.url === item.url
change.version === item.version
change.get === item.get
```

Please see specs and the source code for further examples.
