check = function () {
    if  ($('#store_application_application_type_container').is(':checked'))
        $('#container_fields').show();
    else
        $('#container_fields').hide();

    if  ($('#store_application_application_type_compose_app').is(':checked'))
        $('#compose_app_fields').show();
    else
        $('#compose_app_fields').hide();
}


$(document).ready(function () {
    check();
    $('#store_application_application_type_container').click(check);
    $('#store_application_application_type_compose_app').click(check);
});
