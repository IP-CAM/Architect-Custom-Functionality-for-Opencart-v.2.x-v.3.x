<table class="table table-striped table-hover">
    <thead>
        <tr>
            <th class="text-center" style="width:80px"><?php echo $i18n['text_id']; ?></th>
            <th class="text-left" style="min-width:200px"><?php echo $i18n['text_name']; ?></th>
            <th class="text-center" style="width:80px"><?php echo $i18n['text_status']; ?></th>
            <th class="text-center" style="width:110px">
                <?php echo $i18n['text_action']; ?>
                <a href="#" class="ml-5 js-manage-refresh" data-toggle="tooltip" title="Reload list"><i class="fa fa-refresh"></i></a>
            </th>
        </tr>
    </thead>
    <tbody id="manage-list"></tbody>
</table>

<div class="row pagination-wrapper" style="display:hidden;">
    <div class="col-sm-7 pagination-number"></div>
    <div class="col-sm-5 text-right pagination-info"></div>
</div>

<script>
var urlManageList   = 'index.php?route=<?php echo $architect["path_module"]; ?>/manageList&<?php echo $architect["url_token"]; ?>',
    urlManageUpdate = 'index.php?route=<?php echo $architect["path_module"]; ?>/manageUpdate&<?php echo $architect["url_token"]; ?>';

$(document).ready(function()
{
    fetchManageList(urlManageList);
    $('.js-manage-refresh').on('click', function(e) {
        e.preventDefault();
        fetchManageList(urlManageList);
    });

    $('#tab-manage .pagination-number').on('click', 'a', function(e) {
        e.preventDefault();
        fetchManageList($(this).attr('href'));
    });

    // Update item
    $('#manage-list').on('click', '[data-arc-update]', function(e) {
        e.preventDefault();

        var el = $(this),
            elData = el.data('arc-update');

        $.ajax({
            url: urlManageUpdate + '&_='+ new Date().getTime(),
            type: 'POST',
            dataType: 'json',
            data: elData,
            cache: false,
            beforeSend: function() {
                $('.beforeUpdate').trigger('click'); // close .arc-alert.beforeUpdate

                if (elData.action == 'delete') {
                    if (!confirm(architect.i18n.confirm_delete)) {
                        return false;
                    }
                    el.after('<i class="fa fa-spinner fa-spin spinner-' + elData.id + '"></i>');
                }
            },
            success: function(data) {
                if (!data.error) {
                    fetchManageList(urlManageList);
                } else {
                    notify('danger beforeUpdate', data.error);
                }
            }
        });
    });
});

function fetchManageList(url) {
    $.ajax({
        url: url + '&_='+ new Date().getTime(),
        type: 'POST',
        dataType: 'json',
        cache: false,
        beforeSend: function() {
            $('#manage-list').html('<tr><td class="text-center" colspan="4" style="padding:25px 10px;"><i class="fa fa-spinner fa-spin"></i> ' + architect.i18n.text_processing + '</td></tr>');
            $('.pagination-wrapper').hide(10);
        },
        success: function(data) {
            if (data.items) {
                $('#manage-list').html(data.output);

                $('.pagination-number').html(data.pagination);
                $('.pagination-info').html(data.pagination_info);
                $('.pagination-wrapper').show();
            } else {
                $('#manage-list').html('<tr><td class="text-center" colspan="4" style="padding:25px 10px;">' + architect.i18n.text_no_data + '</td></tr>');
            }
        }
    });
}
</script>