class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button> <button class="split-button">Split</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': -> 
      @model.get('playerHand').hit()

    'click .stand-button': -> 
      @model.get('playerHand').stand()

    'click .split-button': -> 
      @model.get('playerHand').split()

  initialize: ->
    @render()

    @model.get('playerHand').on('stand', => @handleStand())

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
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

  handleStand: ->
    while @model.get('dealerHand').scores()[1] <= 16
      console.log(@model.get('dealerHand').scores()[1]);
      @model.get('dealerHand').hit()

    @model.get('dealerHand').at(0).flip()

    dealerScores = @model.get('dealerHand').scores();
    playerScores = @model.get('playerHand').scores();

    
    if playerScores[1] is dealerScores[1]
      alert 'Push' 
    else if playerScores[1] > dealerScores[1] and playerScores[1] <= 21
      alert 'You win!'
    else 
      alert 'You lose FOOOL!'



