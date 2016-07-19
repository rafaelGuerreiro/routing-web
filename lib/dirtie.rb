module Dirtie
  def dirty?
    @dirty
  end

  def clean?
    !dirty?
  end

  private

  def dirty!
    @dirty = true
  end

  def clean!
    @dirty = false
  end
end
