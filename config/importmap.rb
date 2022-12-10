# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "jquery", to: "https://unpkg.com/jquery@3.4.1/dist/jquery.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/lib/index.js"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "ahoy", to: "https://ga.jspm.io/npm:ahoy@1.0.1/lib/index.js"
pin "os", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.27/nodelibs/browser/os.js"
