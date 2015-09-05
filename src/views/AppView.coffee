class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button> <button class="split-button">Split</button>
    <div class="player-hand-container"></div><div class="player-splithand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': -> 
      @model.get('playerHand').hit()

    'click .stand-button': -> 
      @model.get('playerHand').stand()

    'click .split-button': -> 
      if @model.get('playerHand').split()
        @$el.children('.stand-button').attr('disabled', true)

  initialize: ->
    @render()

    @model.get('playerHand').on('stand', => @handleStand())
    @model.get('playerHand').on('splitting', => 
      @model.get('playerHand').secondHand.on('stand', => @handleStand())
      @model.get('playerHand').secondHand.on('over', -> alert('You went over'))
      @render()
    )

    @model.get('playerHand').on('over', (playerHand) ->
      alert "You went over"
    )

    @model.get('dealerHand').on('over', (dealerHand) ->
      alert "Dealer went over"
    )

    @model.get('playerHand').on('maxed', (playerHand) =>
      @model.get('playerHand').stand()
    )

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    if @model.get('playerHand').secondHand?
      @$('.player-splithand-container').html new HandView(collection: @model.get('playerHand').secondHand).el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el



  handleStand: ->
    while @model.get('dealerHand').scores()[1] <= 16
      console.log(@model.get('dealerHand').scores()[1]);
      @model.get('dealerHand').hit()

    @model.get('dealerHand').at(0).flip()

    dealerScores = @model.get('dealerHand').scores();
    playerScores = @model.get('playerHand').scores();
    secondHandScores = if @model.get('playerHand').secondHand? then @model.get('playerHand').secondHand.scores() else null

    if dealerScores[1] > 21
      @model.get('playerHand').status = 1
    else if playerScores[1] is dealerScores[1]
      @model.get('playerHand').status = 0
    else if playerScores[1] > dealerScores[1] and playerScores[1] <= 21
      @model.get('playerHand').status = 1
    else 
      @model.get('playerHand').status = -1

    if secondHandScores?
      if dealerScores[1] > 21
        @model.get('playerHand').secondHand.status = 1
      else if secondHandScores[1] is dealerScores[1]
        @model.get('playerHand').secondHand.status = 0
      else if secondHandScores[1] > dealerScores[1] and secondHandScores[1] <= 21
        @model.get('playerHand').secondHand.status = 1
      else 
        @model.get('playerHand').secondHand.status = -1

      @model.get('playerHand').secondHand.trigger('finish');

    @model.get('playerHand').trigger('finish');

