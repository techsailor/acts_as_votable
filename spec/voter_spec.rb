require 'acts_as_votable'
require 'spec_helper'

describe ActsAsVotable::Voter do

  before(:each) do
    clean_database
  end

  it "should not be a voter" do
    NotVotable.should_not be_votable
  end

  it "should be a voter" do
    Votable.should be_votable
  end
 
  describe "voting by a voter" do

    before(:each) do
      clean_database
      @voter = Voter.new(:name => 'i can vote!')
      @voter.save

      @voter2 = Voter.new(:name => 'a new person')
      @voter2.save
      
      @votable = Votable.new(:name => 'a voting model')
      @votable.save

      @votable2 = Votable.new(:name => 'a 2nd voting model')
      @votable2.save
    end

    it "should be voted on after a voter has voted" do
      @votable.vote :voter => @voter
      @voter.voted_on?(@votable).should be true
    end

    it "should not be voted on if a voter has not voted" do
      @voter.voted_on?(@votable).should be false
    end

    it "should be voted as true when a voter has voted true" do
      @votable.vote :voter => @voter
      @voter.voted_as_when_voting_on(@votable).should be true
    end

    it "should be voted as false when a voter has voted false" do
      @votable.vote :voter => @voter, :vote => false
      @voter.voted_as_when_voting_on(@votable).should be false
    end

    it "should be voted as nil when a voter has never voted" do
      @voter.voted_as_when_voting_on(@votable).should be nil
    end

    it "should return the total number of votes cast against a given class" do
      @votable.vote :voter => @voter
      @votable2.vote :voter => @voter
      @voter.total_votes_for_class(Votable).should == 2
    end

    it "should provide reserve functionality, voter can vote on votable" do
      @voter.vote :votable => @votable, :vote => 'bad'
      @voter.voted_as_when_voting_on(@votable).should be false
    end

    it "should be thread safe" do
      @voter.vote :votable => @votable, :vote => false
      @voter2.vote :votable => @votable

      @voter.voted_as_when_voting_on(@votable).should be false
    end

  end


end