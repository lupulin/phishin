# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.

//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require history
//= require_tree .

# Generic namespace
Ph = {}

Ph.uniqueID = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < length
  id.substr 0, length

Ph.handleFeedback = (feedback) ->
  if feedback.type == 'notice'
    css = 'feedback_notice'
    icon = 'icon-ok'
  else
    css = 'feedback_alert'
    icon = 'icon-exclamation-sign'
  id = Ph.uniqueID()
  $('#feedback').append("<p class=\"#{css}\" id=\"#{id}\"><i class=\"#{icon}\"></i> #{feedback.msg}</p>")
  setTimeout( ->
    $("##{id}").hide('slide')
  , 3000)

page_init = true
Ph.followLink = ($el) ->
  page_init = false
  # console.log $el
  History.pushState {href: $el.attr 'href'}, $('#app_data').data('app-name'), $el.attr 'href'
  window.scrollTo 0, 0

$ ->
  
  ###############################################
  # Handle feedback initial state on DOM load
  if $('.feedback_notice').html() != ''
    $('.feedback_notice').show('slide')
    setTimeout( ->
      $('.feedback_notice').hide('slide')
    , 3000)
  else
    $('.feedback_notice').hide()
  if $('.feedback_alert').html() != ''
    $('.feedback_alert').show('slide')
    setTimeout( ->
      $('.feedback_alert').hide('slide')
    , 3000)
  else
    $('.feedback_alert').hide()
  
  ###############################################
  # Prepare history.js
  History = window.History
  return false if !History.enabled
  History.Adapter.bind window, 'statechange', ->
    State = History.getState()
    History.log State.data, State.title, State.url
  History.Adapter.bind window, 'popstate', ->   
    state = window.History.getState()
    # console.log state
    if state.data.href != undefined and !page_init
      $('#ajax_overlay').css 'visibility', 'visible'
      $('#page').load(
        state.data.href, (response, status, xhr) ->
          alert("ERROR\n\n"+response) if status == 'error'
      )
      $('#ajax_overlay').css 'visibility', 'hidden'

  # Click a link to load context via ajax
  $(document).on 'click', 'a', ->
    unless $(this).hasClass('non-remote')
      Ph.followLink $(this) if $(this).attr('href') != "#" and $(this).attr('href') != 'null'
      false
    
  $(document).on 'click', 'a.download', ->
    $this = $(this)
    $.ajax({
      url: '/user-signed-in',
      dataType: 'json',
      success: (r) ->
        if r.success
          # Ph.handleFeedback({ 'type': 'notice', 'msg': 'Requesting download...' })
          window.location = $this.data('url') if $this.data('url') != undefined
        else
          Ph.handleFeedback({ 'type': 'alert', 'msg': r.msg })
    })

  ###############################################
  
  # Like tooltip
  $('.likes_large a').tooltip({
    placement: 'bottom',
    delay: { show: 500, hide: 0 }
  })
  $('.likes_small > a').tooltip({
    delay: { show: 500, hide: 0 }
  })
  
  # Click a like to submit to server
  $(document).on 'click', '.like_toggle', ->
    $this = $(this)
    $.ajax({
      type: 'post',
      url: '/toggle-like',
      data: { 'likable_type': $this.data('type'), 'likable_id': $this.data('id') }
      dataType: 'json',
      success: (r) ->
        if r.success
          if r.liked then $this.addClass('liked') else $this.removeClass('liked')
          Ph.handleFeedback({ 'type': 'notice', 'msg': r.msg })
          $this.siblings('span').html(r.likes_count)
        else
          Ph.handleFeedback({ 'type': 'alert', 'msg': r.msg })
    })
  
  # User sign up / sign in tabs
  $('#user_tabs a:last').tab('show');
  
  # Rollover year to reveal number of shows
  $(document).on 'mouseover', '.year_list > li', ->
    $(this).find('h2').css 'visibility', 'visible'
  $(document).on 'mouseout', '.year_list > li', ->
    $(this).find('h2').css 'visibility', 'hidden'

  # Rollover item list to reveal context button
  $(document).on 'mouseover', '.item_list > li', ->
    $(this).find('.btn_context').css 'visibility', 'visible'
  $(document).on 'mouseout', '.item_list > li', ->
    $(this).find('.btn_context').css 'visibility', 'hidden'

  # Rollover header to reveal context button
  $(document).on 'mouseover', '#header', ->
    $(this).find('.btn_context').css 'visibility', 'visible'
  $(document).on 'mouseout', '#header', ->
    $(this).find('.btn_context').css 'visibility', 'hidden'
    
  # Follow links in .year_list
  $(document).on 'click', '.year_list > li', ->
    Ph.followLink $(this).find 'a'
  
  # Follow h1>a links in .item_list.clickable > li
  $(document).on 'click', '.item_list > li', ->
    if $(this).parent('ul').hasClass 'clickable'
      Ph.followLink $(this).children('h2').find 'a'
  
  # Share links bring up
  $(document).on 'click', '.share', ->
    $('#share_modal_body').html("<p>"+$('#app_data').data('base-url')+$(this).data('url')+"</p>")
    $('#share_modal').modal('show')
    