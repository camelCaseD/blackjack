class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->
    @secondHand = null
    @status = null;

  hit: ->
    if @scores()[1] < 21
      @add(@deck.pop())
      if @scores()[1] > 21 and @scores()[0] > 21 # did we go over after getting a new card?
        @trigger 'over', @
    else if @scores()[0] is 21 or @scores()[1] is 21
        @trigger 'maxed'
    else if @scores()[0] > 21 or @scores()[1] > 21
      @add(@deck.pop())
      @trigger 'over', @
    
    @last()


  split: ->
    canSplit = @at(0).get('value') is @at(1).get('value') and @length is 2
    
    if canSplit
     
      #split hand
      @secondHand = new Hand([@at(1)], @deck)
      @secondHand.secondHand = true
      @remove(@at(1));

      #deal one additional card per split hand
      @add(@deck.pop())
      @secondHand.add(@deck.pop())
      #add stand button below each split hand
      #add hit button below each split hand
      @trigger('splitting')

      return true
    false








  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + card.get 'value'
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  stand: ->
    if @secondHand? and typeof @secondHand isnt 'boolean' # checks to see if second hand exists from this hand
      # I'm the first hand
      @trigger('disableControls')
    else
      @trigger('stand', @)



