FactoryBot.define do
  factory :project do
    name { "GitLab" }
    slug { "gitlab" }
    github { "gitlabhq/gitlabhq" }
    rails_major_version { 5 }
  end
end
