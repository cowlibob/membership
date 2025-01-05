# Pin npm packages by running ./bin/importmap

pin "application"
pin "stimulus" # @3.2.2
pin "turbo" # @2.3.3
pin "child_process" # @2.1.0
pin "fs" # @2.1.0
pin "path" # @2.1.0
pin "process" # @2.1.0

pin_all_from 'app/javascript/controllers', under: 'controllers', to: 'controllers'
