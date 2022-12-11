class ComparePresenter
  class Comparison
    def initialize(gem, gem_tag, context = {})
      @gem = gem
      @gem_tag = gem_tag
      @context = context
    end

    def score
      return 0 if @gem_tag.nil?

      @score ||= @gem_tag.visible_taggings_count.to_f / @context[:total_projects].to_f
    end

    def name
      @gem
    end

    def rank
      @rank ||= begin
                  if score.between?(0.0, 0.02)
                    :dubious
                  elsif score.between?(0.02, 0.05)
                    :obscure
                  elsif score.between?(0.05, 0.10)
                    :relatively_unused
                  elsif score.between?(0.10, 0.15)
                    :niche
                  elsif score.between?(0.15, 0.25)
                    :good
                  else
                    :popular
                  end
                end
    end
  end

  def self.build(owned_gems)
    new(owned_gems).build
  end

  def initialize(owned_gems)
    @owned_gems = owned_gems
    @list = {}
  end

  def build
    found = TagCache.gems.select { |gem| @owned_gems.include?(gem.name) }.index_by(&:name)
    total_projects = Project.visible.size
    @list = Hash.new { |hash, key| hash[key] = Array.new }

    @owned_gems.each do |gem|
      comparison = Comparison.new(gem, found[gem], total_projects: total_projects)
      @list[comparison.rank] << comparison
    end

    @list.each do |k, _|
      @list[k] = @list[k].sort_by { |gem| gem.name }
    end
    self
  end

  def each(&block)
    @list.each(&block)
  end
end
