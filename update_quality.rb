require 'award'

def update_quality(awards)
  awards.each do |award|
    @award = award
    name = @award.name
    quality = @award.quality

    # Blue Distinction Plus awards are not be altered
    if name == "Blue Distinction Plus"
      return 
    end

    # Manipulate @award data based on name.
    update_quality_normal if name == "NORMAL ITEM"
    update_quality_blue_star if name == "Blue Star"
    update_quality_blue_compare if name == "Blue Compare"
    update_quality_blue_first if name == "Blue First"

    # all awards move one day towards expiration
    @award.expires_in -=1  
    
    # reset the iterable award @award for backwards compatibility
    award = @award
  end
end

################# NORMAL ITEM and Blue Star Award methods #################
def update_quality_normal
  normal_and_blue_star_quality(1, 2)
end

def update_quality_blue_star
  normal_and_blue_star_quality(2, 4)
end

def normal_and_blue_star_quality(unexpired, expired)
  if @award.quality > 1
    @award.quality -= unexpired if @award.expires_in > 0
    @award.quality -= expired if @award.expires_in <= 0
  else 
    @award.quality = 0
  end
  @award.quality = 0 if @award.quality < 0
end

################# Blue Compare and Blue First Award methods #################
def update_quality_blue_compare
  return @award.quality = 50 if @award.quality >= 50 
  under_fifty_quality(2, 3)
end

def update_quality_blue_first
  return @award.quality = 50 if @award.quality >= 50 
  under_fifty_quality(1, 1)
end

def under_fifty_quality(far, close)
  if @award.expires_in <= 10 && @award.expires_in > 5
    @award.quality += far
  elsif @award.expires_in > 0 && @award.expires_in <= 5
    @award.quality += close
  elsif @award.expires_in <= 0
    if @award.name == "Blue First"
      @award.quality += 1
      @award.quality = 50 if @award.quality >= 50
      @award.quality += 1 if @award.quality < 50
    elsif @award.name == "Blue Compare"
      @award.quality = 0
    end
  else 
    @award.quality += 1
  end
end
