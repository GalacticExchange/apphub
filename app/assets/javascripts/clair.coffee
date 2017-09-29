$ ->
  $('.clair_wrap.row').each( () ->

    $( $(this).find('.vulnerability.flex')[0] ).addClass('selected-menu')
    $( $(this).find('.vul')[0] ).addClass('selected-vul')
    $( $(this).find('.vulnerability.flex') ).click (event) ->

      $(this).closest('.clair_wrap.row').find('.vulnerability.flex.selected-menu').removeClass('selected-menu')
      $(this).closest('.clair_wrap.row').find('.vul.selected-vul').removeClass('selected-vul')
      target_id = $(this).data('target')
      $('#' + target_id).addClass('selected-vul')
      $(this).addClass('selected-menu')


    )