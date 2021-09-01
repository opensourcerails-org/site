FactoryBot.define do
  factory :stack, class: "ActsAsTaggableOn::Tag" do
    name { "rspec" }
    data { { stack: true } }
  end

  factory :notable, class: "ActsAsTaggableOn::Tag" do
    name { "notable-tag" }
    data { { notable: true } }
  end

  factory :gem, class: "ActsAsTaggableOn::Tag" do
    name { "some-gem" }
    after(:create) do |instance|
      create(:project) do |prj|
        prj.gems << instance
      end
    end
  end

  factory :package, class: "ActsAsTaggableOn::Tag" do
    name { "everchanging-js" }
    after(:create) do |instance|
      create(:project) do |prj|
        prj.packages << instance
      end
    end
  end

  factory :adjective, class: "ActsAsTaggableOn::Tag" do
    name { "very-cool" }
    after(:create) do |instance|
      create(:project) do |prj|
        prj.adjectives << instance
      end
    end
  end

  factory :license, class: "ActsAsTaggableOn::Tag" do
    name { "MIT-License" }
    after(:create) do |instance|
      create(:project) do |prj|
        prj.license << instance
      end
    end
  end

  factory :app_directory, class: "ActsAsTaggableOn::Tag" do
    name { "services" }
    after(:create) do |instance|
      create(:project) do |prj|
        prj.app_directories << instance
      end
    end
  end

  factory :backend_stack, class: "ActsAsTaggableOn::Tag" do
    name { "rspec" }
    after(:create) do |instance|
      create(:project) do |prj|
        prj.backend_stack << instance
      end
    end
  end

  factory :frontend_stack, class: "ActsAsTaggableOn::Tag" do
    name { "stimulus" }
    after(:create) do |instance|
      create(:project) do |prj|
        prj.frontend_stack << instance
      end
    end
  end
end
