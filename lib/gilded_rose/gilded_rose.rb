require_relative 'item'

class GildedRose
  attr_reader :items

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def initialize
    @items = []
    items << Item.new("+5 Dexterity Vest", 10, 20)
    items << Item.new("Aged Brie", 2, 0)
    items << Item.new("Elixir of the Mongoose", 5, 7)
    items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    items << Item.new("Conjured Mana Cake", 3, 6)
  end

  def update_quality
    items.each { |item| update_item(item) }
  end

  def update_item(item)
    if item.name =~ /Conjured/
      2.times { decrease_item_quality(item) }
      item.sell_in -= 1
      if (item.sell_in < 0)
        2.times { decrease_item_quality(item) }
      end
      return
    end

    if item.name == "Sulfuras, Hand of Ragnaros"
      return
    end

    if item.name == "Aged Brie"
      increase_item_quality(item)
      item.sell_in -= 1
      if item.sell_in < 0
        increase_item_quality(item)
      end
      return
    end

    # if item.name == "Backstage passes to a TAFKAL80ETC concert"
    #   increase_item_quality(item)
    #   if item.sell_in < 11
    #     increase_item_quality(item)
    #   end
    #   if item.sell_in < 6
    #     increase_item_quality(item)
    #   end
    #   item.sell_in -= 1
    #   if item.sell_in < 0
    #     item.quality = 0
    #   end
    #   return
    # end

    if item.name != "Backstage passes to a TAFKAL80ETC concert"
      decrease_item_quality(item)
    else
      if item.quality < MAX_QUALITY
        item.quality += 1
        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          if item.sell_in < 11
            increase_item_quality(item)
          end
          if item.sell_in < 6
            increase_item_quality(item)
          end
        end
      end
    end
    item.sell_in -= 1
    if item.sell_in < 0
      if item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.name != "Sulfuras, Hand of Ragnaros"
          decrease_item_quality(item)
        end
      else
        item.quality = 0
      end
    end
  end

  def decrease_item_quality(item)
    if item.quality > MIN_QUALITY
      item.quality -= 1
    end
  end

  def increase_item_quality(item)
    if item.quality < MAX_QUALITY
      item.quality += 1
    end
  end

end
