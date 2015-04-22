require "approvals/rspec"

RSpec.describe GildedRose do
  let(:items) do
    subject.items.map do |item|
      "Name: #{item.name} Sell-in: #{item.sell_in} Quality: #{item.quality}"
    end
  end

  20.times do |i|
    specify "after #{i} updates" do
      i.times { subject.update_quality }
      verify { items }
    end
  end

  describe "conjured items" do
    let(:item) { Item.new("Conjured something", 5, 10) }
    before do
      subject.update_item(item)
    end

    it "decreases quality by 2 each day" do
      expect(item.quality).to eq 8
    end

    it "decreases sell_in by 1 each day" do
      expect(item.sell_in).to eq 4
    end

    context "past the sell_in date" do
      let(:item) { Item.new("Conjured old item", -1, 10) }

      it "decreases twice as fast" do
        expect(item.quality).to eq 6
      end
    end
  end

  describe "sulfuras" do
    let(:item) { Item.new("Sulfuras, Hand of Ragnaros", 10, 10) }
    before do
      subject.update_item(item)
    end

    it "never decreases in quality" do
      expect(item.quality).to eq 10
    end

    it "never decreases sell_in" do
      expect(item.sell_in).to eq 10
    end
  end

  describe "aged brie" do
    let(:item) { Item.new("Aged Brie", 5, 10) }
    before do
      subject.update_item(item)
    end

    it "increases quality by 1 each day" do
      expect(item.quality).to eq 11
    end

    it "decreases sell_in by 1 each day" do
      expect(item.sell_in).to eq 4
    end

    context "past the sell_in date" do
      let(:item) { Item.new("Aged Brie", -1, 10) }

      it "increases quality twice as fast" do
        expect(item.quality).to eq 12
      end
    end
  end

  describe "backstage passes" do
    let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", 20, 10) }
    before do
      subject.update_item(item)
    end

    it "increases quality by 1 each day" do
      expect(item.quality).to eq 11
    end

    it "decreases sell_in by 1 each day" do
      expect(item.sell_in).to eq 19
    end

    context "past the sell_in date" do
      let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 10) }

      it "decreases quality zero" do
        expect(item.quality).to eq 0
      end

      it "decreases the sell_in date by 1" do
        expect(item.sell_in).to eq -2
      end
    end
  end
end
