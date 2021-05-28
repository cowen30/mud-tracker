$(document).on('turbolinks:load', () => {
    $('.clickable-row').on('click', (event) => {
        window.location = $(event.currentTarget).data('href');
    });

    $('.data-table').DataTable(getTableParams({'search': false}));

    $('#user-add-participant-button, #event-add-participant-button').on('click', (event) => {
        const participantData = $('#participant-form').serialize();
        $.ajax({
            method: 'POST',
            url: $('#participant-form').attr('action'),
            data: participantData
        }).done((data) => {
            $('#participantModal').modal('hide');
            
            let firstColumnData = data.event_detail.event.name
            
            if ($(event.currentTarget).attr('id') === 'event-add-participant-button') {
                firstColumnData = data.user.first_name + ' ' + data.user.last_name;
            }

            let row = addRowToTable('#participant-table', [
                firstColumnData,
                data.event_detail.event_type.name,
                data.participation_day
            ]);

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
    let table = $(tableId).DataTable();
    return table.row.add(rowData).draw().node();
}

const addAttributesToRow = (row, attrs) => {
    $.each(attrs, (key, value) => {
        $(row).attr(key, value);
    });
}
