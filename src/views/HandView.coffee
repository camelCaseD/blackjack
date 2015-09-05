class window.HandView extends Backbone.View
  className: 'hand'

  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> (<span class="scoreMin"></span>) or (<span class="scoreMax"></span>)</h2>'

  events:
    'click .hit-hand-button': -> 
      @collection.hit()

    'click .stand-hand-button': -> 
      @collection.stand()

  initialize: ->
    @collection.on 'add remove change', => @render()
    @collection.on 'disableControls', =>
      @$el.children('button').attr('disabled', true);
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    @$('.scoreMin').text @collection.scores()[0]
    @$('.scoreMax').text @collection.scores()[1]

    if @collection.secondHand?
      @$el.append('<button class="hit-hand-button">Hit</button><button class="stand-hand-button">Stand</button>')

