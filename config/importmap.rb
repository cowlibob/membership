# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/stimulus-importmap-autoloader", to: "stimulus-importmap-autoloader.js"

# pin "stimulus" # @3.2.2
# pin "turbo" # @2.4.2
# pin "child_process" # @2.1.0
# pin "fs" # @2.1.0
# pin "path" # @2.1.0
# pin "process" # @2.1.0

pin_all_from 'app/javascript/controllers', under: 'controllers', to: 'controllers'
pin "controllers/application", to: "controllers/application.js"
# pin "@hotwired/turbo-rails", to: "turbo.min.js"
