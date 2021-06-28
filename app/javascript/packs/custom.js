const PWD_VALIDATION_SATISFIED_CLASSES = 'text-success fw-bold';
const PWD_VALIDATION_UNSATISFIED_CLASSES = 'text-muted';
let passwordIsValid = false;

$(document).on('turbolinks:load', () => {
    registerPasswordRequirementValidations();

    $('.clickable-row').on('click', (event) => {
        window.location = $(event.currentTarget).data('href');
    });

    $('.data-table').DataTable(getTableParams({'search': false}));

    $('#participantModal').on('show.bs.modal', (event) => {
        const participantId = $(event.relatedTarget).data('participant');
        if (participantId == undefined) {
            $('#delete-participant').addClass('d-none');
            $('#participant-modal-label').text('Add');
        } else {
            $('#delete-participant').removeClass('d-none');
            $('#participant-modal-label').text('Edit');
        }
        
        $('#participant_id').val(participantId);
        $('#participant_event_detail_attributes_event_id').val($(event.relatedTarget).data('event'));
        $('#participant_event_detail_attributes_event_type_id').val($(event.relatedTarget).data('type'));
        const brandId = $('#participant_event_detail_attributes_event_id').find('option:selected').data('brand');
        updateEventDropdown(brandId);
        updateEventTypeDropdown(brandId);

        const race_day = $(event.relatedTarget).data('day');
        if (race_day == undefined || race_day == '') {
            $('input[name="participant[participation_day]"][value="Saturday"]').prop('checked', false);
            $('input[name="participant[participation_day]"][value="Sunday"]').prop('checked', false);
        } else {
            $('input[name="participant[participation_day]"][value="' + race_day + '"]').prop('checked', true);
        }
    });

    $('#participant_event_detail_attributes_event_id').on('change', (event) => {
        const selectedBrand = $(event.currentTarget).find('option:selected').data('brand');
        updateEventTypeDropdown(selectedBrand);
    });

    $('#participant_event_detail_attributes_event_type_id').on('change', (event) => {
        const selectedBrand = $(event.currentTarget).find('option:selected').data('brand');
        updateEventDropdown(selectedBrand);
    });

    $('#delete-participant').on('click', (event) => {
        const participantId = $('#participant_participant_id').val();
        $.ajax({
            method: 'DELETE',
            url: '/participants/' + participantId
        }).done((data) => {
            $('#participantModal').modal('hide');
            const table = $('#participant-table').DataTable();
            const participantRow = $('#participant-table tr[data-participant="' + participantId + '"]');
            participantRow.fadeOut('500', () => {
                table.row(participantRow).remove().draw();
            });
        }).fail(() => {
            alert('Error!');
        });
    });

    $('#user-add-participant-button, #event-add-participant-button').on('click', (event) => {
        const participantData = $('#participant-form').serialize();
        const participantId = $('#participant_id').val();
        let method = 'POST';
        let url = '/participants'
        if (participantId != '') {
            method = 'PUT';
            url = '/participants/' + participantId;
        }
        $.ajax({
            method: method,
            url: url,
            data: participantData
        }).done((data) => {
            $('#participantModal').modal('hide');
            
            let firstColumnData = data.event_detail.event.name

            if ($(event.currentTarget).attr('id') === 'event-add-participant-button') {
                firstColumnData = data.user.first_name + ' ' + data.user.last_name;
            }

            let row = undefined;
            const rowData = [
                firstColumnData,
                data.event_detail.event_type.name,
                data.participation_day
            ];

            if (participantId == '') {
                row = addRowToTable('#participant-table', rowData);
                $(row).addClass('table-row');
            } else {
                const rowIndex = $('#participant-table tr[data-participant=' + participantId + ']').index();
                row = editRowInTable('#participant-table', rowIndex, rowData);
            }
    
            addAttributesToRow(row, {
                'data-bs-toggle': 'modal',
                'data-bs-target': '#participantModal',
                'data-participant': data.id,
                'data-event': data.event_detail.event_id,
                'data-user': data.user_id,
                'data-type': data.event_detail.event_type_id,
                'data-day': data.participation_day
            });
        }).fail(() => {
            alert('Error!');
        });
    });

    $('.brand-logo').on('click', (event) => {
        if ($(event.currentTarget).hasClass('border')) {
            $(event.currentTarget).removeClass(['border', 'border-secondary']);
        } else {
            $(event.currentTarget).find('input').prop('checked', true);
            $(event.currentTarget).addClass(['border', 'border-secondary']);
        }
        $(event.currentTarget).parent().siblings().children('.brand-logo').removeClass(['border', 'border-secondary']);
    });
});

const getTableParams = (options) => {
    var search = false;
    if (options === undefined || options.search === undefined || options.search === true) {
      search = true;
    }
    return {
      "order": [],
      "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
      iDisplayLength: -1,
      "paging": false,
      "info": false,
      "searching": search
    };
}

const addRowToTable = (tableId, rowData) => {
    const table = $(tableId).DataTable();
    return table.row.add(rowData).draw().node();
}

const editRowInTable = (tableId, index, rowData) => {
    const table = $(tableId).DataTable();
    return table.row(index).data(rowData).draw().node();
}

const addAttributesToRow = (row, attrs) => {
    $.each(attrs, (key, value) => {
        $(row).attr(key, value);
    });
}

const updateEventDropdown = (brandId) => {
    $('#participant_event_detail_attributes_event_id option:not(:first)').each((_, element) => {
        if (brandId == undefined) {
            $(element).removeClass('d-none');
        } else {
            $(element).toggleClass('d-none', $(element).data('brand') !== brandId);
        }
    });
}

const updateEventTypeDropdown = (brandId) => {
    $('#participant_event_detail_attributes_event_type_id option:not(:first)').each((_, element) => {
        if (brandId == undefined) {
            $(element).removeClass('d-none');
        } else {
            $(element).toggleClass('d-none', $(element).data('brand') !== brandId);
        }
    });
}

const registerPasswordRequirementValidations = () => {
    $('#password-input').on('keyup', (event) => {
        let pwd = $(event.currentTarget).val();
        let pwdConfirm = $('#confirm-password-input').val();
        if (isValidPassword(pwd)) {
            passwordIsValid = true;
            if (validatePasswordConfirmation(pwd, pwdConfirm)) {
                $('#submit-button').attr('disabled', false);
            }
        } else {
            passwordIsValid = false;
            $('#submit-button').attr('disabled', true);
        }
    });
    $('#confirm-password-input').on('keyup', (event) => {
        let pwd = $('#password-input').val();
        let pwdConfirm = $(event.currentTarget).val();
        if (passwordIsValid) {
            if (validatePasswordConfirmation(pwd, pwdConfirm)) {
                $('#submit-button').attr('disabled', false);
            } else {
                $('#submit-button').attr('disabled', true);
            };
        }
    });
}

const isValidPassword = (pwd) => {
    return validatePasswordLength(pwd) & validatePasswordUppercase(pwd) & validatePasswordSpecialChars(pwd);
}

const validatePasswordLength = (pwd) => {
    if (pwd.length >= 8 && pwd.length <= 100) {
        $('#password-req-length').addClass(PWD_VALIDATION_SATISFIED_CLASSES).removeClass(PWD_VALIDATION_UNSATISFIED_CLASSES);
        return true;
    } else {
        $('#password-req-length').addClass(PWD_VALIDATION_UNSATISFIED_CLASSES).removeClass(PWD_VALIDATION_SATISFIED_CLASSES);
        return false;
    }
}

const validatePasswordUppercase = (pwd) => {
    if (pwd.toLowerCase() != pwd) {
        $('#password-req-char-upper').addClass(PWD_VALIDATION_SATISFIED_CLASSES).removeClass(PWD_VALIDATION_UNSATISFIED_CLASSES);
        return true;
    } else {
        $('#password-req-char-upper').addClass(PWD_VALIDATION_UNSATISFIED_CLASSES).removeClass(PWD_VALIDATION_SATISFIED_CLASSES);
        return false;
    }
}

const validatePasswordSpecialChars = (pwd) => {
    if (/[!@#$%^&*]/.test(pwd)) {
        $('#password-req-char-special').addClass(PWD_VALIDATION_SATISFIED_CLASSES).removeClass(PWD_VALIDATION_UNSATISFIED_CLASSES);
        return true;
    } else {
        $('#password-req-char-special').addClass(PWD_VALIDATION_UNSATISFIED_CLASSES).removeClass(PWD_VALIDATION_SATISFIED_CLASSES);
        return false;
    }
}

const validatePasswordConfirmation = (pwd, pwdConfirm) => {
    return (pwd === pwdConfirm);
}
