

/** Funtion check valid lat-lng */
function checkLatLng(lat, lng) {
    if ((lat != '' && lng != '')) {
        lat = parseInt(lat), lng = parseInt(lng);
        if (lat < -90 || lat > 90) {
            return false;
        } else if (lng < -180 || lng > 180) {
            return false;
        } else {
            return true;
        }
    } else {
        return false;
    }
}

/** Auto render empty template */
function getEmptyTemplate(col, title = '') {
    if (title == '') { title = 'Không tìm thấy dữ liệu'; }
    return `<tr class="text-muted"><td colspan="${col}" class="text-center"><div class="text-center text-muted pt-4 pb-4"><p class="mb-0"><i class="mdi mdi-48px mdi-folder-open-outline"></i></p><p>Không tìm thấy dữ liệu</p></div></td></tr>`
}

/** Auto render empty template for div */
function getEmptyTemplateForDiv(col, title = '') {
    if (title == '') { title = 'Không tìm thấy dữ liệu'; }
    return `<div class="text-center text-muted pt-2 pb-2"><p class="mb-0"><i class="mdi mdi-48px mdi-folder-open-outline"></i></p><p>Không tìm thấy dữ liệu</p></div>`;
}


/** Get parameter from url */
function getUrlParam(param) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;
    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] === param) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};

/** Get date array from date to date */
function getDayArray(startDate, endDate) {
    let dateArray = new Array();
    let currentDate = new Date(startDate);
    while (currentDate <= endDate) {
        dateArray.push({
            day: moment(currentDate).format('DD/MM/YYYY'),
            utcDay: currentDate.getUTCDay(),
            date: currentDate.getDate(),
            ymd: moment(currentDate).format('YYYY/MM/DD')
        });
        currentDate.setDate(currentDate.getDate() + 1);
    }
    return dateArray;
}

/** Serialize from to data json */
function formToObject(nameForm) {
    let obj = {};
    let a = $(nameForm).serializeArray();
    $.each(a, function (index, item) {
        obj[item.name] = item.value;
    });
    return obj;
}


/** Get start-date and end-date in daterangepicker */
function getDateRangeValue(string) {
    let arr = string.split(' - ');
    return {
        startDate: arr[0],
        endDate: arr[1]
    }
}

/** Dropzone init function */
function initDropzone(selector, success, error) {
    var myDropzone = new Dropzone('#' + selector, {
        url: ROOT_API + '/Storage/Upload',
        acceptedFiles: '.jpeg,.jpg,.png,.pdf',
        headers: { 'X-Token': getToken() },
        chunkSize: 5000000,
        previewsContainer: false
    });
    myDropzone.on('success', function (file, re) { success(file, re); });
    myDropzone.on('error', function (file, re) { error(file, re); });
}

/** Render file */
function renderImageFile(filePath) {
    let ex = filePath.substring(filePath.lastIndexOf('.') + 1, filePath.length) || filePath;
    let imgArr = ['png', 'jpg'];
    if (imgArr.includes(ex.toLowerCase())) {
        return `<img data-dz-thumbnail src='${ROOT_URL + filePath}' class='avatar-sm rounded bg-light'/>`;
    } else if (ex.toLowerCase() == 'pdf') {
        return `<img data-dz-thumbnail src='/Images/Default/pdf-logo.png' class='avatar-sm rounded bg-light'/>`;
    } else {
        return `<img data-dz-thumbnail src='/Images/Default/small-image.png' class='avatar-sm rounded bg-light'/>`;
    }
}


// init search
function initSelectSearch(op) {
    //{
    //    element = elment
    //    url  = đường đẫ api
    //    KeyName = Tên thuộc tính params,
    //    Placehoder  == Hiển thị text mờ tìm theo tên hay mã
    //    propertyName tên thuộc tính đk map vói thuộc tính 'text' của select 2
    //    PropertyId = tên thuộc tính đk map vói thuộc tính 'id' của select 2
    //    img = {
    //             Type  =  Hình ảnh hiển thị bên cạnh template output của select 1, input=> 'icon' or 'img'
    //             Text   img.Type == icon  thì img.text truyền vào class icon  ---  nếu  img.Type == img  thì img.text truyền vào class url của hình ảnh
    //          }
    //}

    $(op.element).select2({
        ajax: {
            url: `${ROOT_API}${op.url}`,
            type: 'GET',
            beforeSend: function (xhr) {
                let auth = getToken();
                if (auth != undefined) {
                    xhr.setRequestHeader('X-Token', auth);
                }
            },
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            delay: 200,
            data: function (params) {
                {
                    if (op.KeyName == "")
                        return "";
                    else
                        return { [op.KeyName]: params.term }
                }
            },
            processResults: function (data) {
                return {
                    results: $.map(data.Result, function (item) {
                        console.log(item);
                        return {
                            text: item[op.propertyName],
                            id: item[op.PropertyId],
                            img: item[op.img.Text]
                        }
                    })
                };
            },
            cache: true
        },
        language: 'vi',
        width: '100%',
        placeholder: op.placehoder,
        escapeMarkup: function (markup) { return markup; },
        minimumInputLength: 1,
        templateResult: function (repo) {
            if (repo.loading) { return repo.text; }
            if (op.img == null)
                return `<p class="m-b-0">${repo.text}</p>`;
            else {
                if (op.img.Type == 'icon')
                    return `<p class="m-b-0"><i class ="mr-2 ${op.img.Text}"></i> ${repo.text}</p>`;
                else (op.img.Type == 'img')
                return `<p class="m-b-0"><img class="mr-2 rounded-circle" style="width:30px" onerror="this.src='${DEFAULT_AVATAR}'"  src ="${repo[op.img.Text]}"/></i> ${repo.text}</p>`;
            }
        }
    });
}
