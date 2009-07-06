require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  dataset :tags
  
  it "should report itself taggable" do
    Page.is_taggable?.should be_true
  end

  it "should return a list of pages form tag list" do
    Page.tagged_with("colourless").should == [pages(:first)]
  end
  
  it "should return a weighted list of tags from page list" do
    Page.tags_for_cloud_from([pages(:first)]).should == Tag.from_list("Colourless, Ideas, Sleep, Furiously")
  end
  
  describe "instantiated with tags" do
    before do
      @page = pages(:first)
    end
    
    it "should return tag list" do
      @page.attached_tags.should == Tag.from_list("Colourless, Ideas, Sleep, Furiously")
    end
    
    it "should add and remove tags" do
      @page.add_tag("Howdy")
      @page.attached_tags.should == Tag.from_list("Colourless, Ideas, Sleep, Furiously, Howdy")
      @page.remove_tag("Howdy")
      @page.attached_tags.should == Tag.from_list("Colourless, Ideas, Sleep, Furiously")
      Tag.for('Howdy').pages.include?(@page).should be_false
    end

    it "should return tags string as keywords" do
      @page.keywords.should == "Colourless, Ideas, Sleep, Furiously"
    end

    it "should accept tags string as keywords=" do
      @page.keywords = "Lovable, Rogue"
      @page.attached_tags.should == [Tag.for("Lovable"), Tag.for("Rogue")]
      @page.keywords.should == "Lovable, Rogue"
    end

    it "should return keywords string to keywords_before_type_cast (for form helpers)" do
      @page.keywords_before_type_cast.should == "Colourless, Ideas, Sleep, Furiously"
    end
    
    it "should return a list of related pages" do
      @page.related.include?(pages(:another)).should be_true
      @page.related.include?(pages(:child)).should be_false
      @page.related.include?(pages(:grandchild)).should be_true
    end
  end
  
  describe "when cloud-building" do
    describe "across the whole collection" do
      before do
        @tags = Tag.banded(Tag.most_popular(10))
      end
      
      it "should weight the tags" do
        tag = @tags.select{|t| t.title = "Ideas"}.first
        tag.cloud_band.should_not be_nil
        tag.use_count.should == "3"                 # counting every use
      end
    end
    
    before do
      @page = pages(:parent)
      @tags = @page.tags_for_cloud
    end
    
    it "should gather its descendants" do
      @page.with_children.length.should == 6
      @page.with_children.include?(pages(:child_2)).should be_true
      @page.with_children.include?(pages(:great_grandchild)).should be_true
    end

    it "should return a weighted list of tags attached to itself and descendants" do
      @tags.first.should == tags(:ideas)
      @tags.first.cloud_band.should_not be_nil
      @tags.first.use_count.should == "1"           # counting only within this family tree
    end

  end
end