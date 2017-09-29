$(document).ready(function() {
    $("#search-filter-clear").click( function(event){
        event.preventDefault();
        form = $('#adv-search-form')

        checkbox_wrap = form.find('.is-checked.mdl-checkbox')
        checkbox_wrap.removeClass('is-checked')
        checkbox_wrap.find('input').prop('checked',false)

        text_inputs = form.find(':text')
        text_inputs.val('')
    });
});
