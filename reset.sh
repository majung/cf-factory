#!/bin/bash

sudo gem uninstall cf_factory
gem build cf_factory.gemspec
sudo gem install ./cf_factory-0.0.3.gem
