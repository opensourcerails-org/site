class ComparesController < ApplicationController
  def show
    @form = CompareForm.new
  end

  def create
    begin
      file = Tempfile.new
      file.write params[:compare_form][:gemfile]
      file.rewind
      gems = Bundler::LockfileParser.new(params[:compare_form][:gemfile]).dependencies.map { |item| item[0] }
      @presenter = ComparePresenter.build(gems)
    ensure
      file.close
    end
  end
end
