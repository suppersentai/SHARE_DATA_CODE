

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
////////////////////////////////
/** Alert toast config */
const alert = {
    info: function (text) { $.toast({ text: text, position: 'bottom-right', icon: 'info', loader: false }) },
    warning: function (text) { $.toast({ text: text, position: 'bottom-right', icon: 'warning', loader: false }) },
    error: function (text) { $.toast({ text: text, position: 'bottom-right', icon: 'error', loader: false }) },
    success: function (text) { $.toast({ text: text, position: 'bottom-right', icon: 'success', loader: false }) }
}

/** Auto render empty template */
function htmlEmptyTable(col = 10, title = 'Không tìm thấy dữ liệu') {
    if (title == '') { title = 'Không tìm thấy dữ liệu'; }
    return `<tr class="text-muted"><td colspan="${col}" class="text-center"><div class="text-center text-muted pt-4 pb-4"><p class="mb-0"><i class="mdi mdi-48px mdi-folder-open-outline"></i></p><p>${title}</p></div></td></tr>`
}

/** Auto render empty template */
function htmlEmptyTableAuto(element, title = '') {
    let col = $(element).find('th').length;
    if (title == '') { title = 'Không tìm thấy dữ liệu'; }
    return `<tr class="text-muted"><td colspan="${col}" class="text-center"><div class="text-center text-muted pt-4 pb-4"><p class="mb-0"><i class="mdi mdi-48px mdi-folder-open-outline"></i></p><p>Không tìm thấy dữ liệu</p></div></td></tr>`
}

/** Auto render empty template for div */
function getEmptyTemplateForDiv(title = '') {
    if (title == '') { title = 'Không tìm thấy dữ liệu'; }
    return `<div class="text-center m-auto text-muted pt-2 pb-2" id="empty-div"><p class="mb-0"><i class="mdi mdi-48px mdi-folder-open-outline"></i></p><p>${title}</p></div>`;
}

/** Init NProgress */
window.addEventListener('DOMContentLoaded', () => {
    try {
        if (NProgress != undefined)
            NProgress.configure({ showSpinner: true });
        var oldXHR = window.XMLHttpRequest;
        function newXHR() {
            var realXHR = new oldXHR();
            realXHR.addEventListener("readystatechange", function () {
                if (realXHR.readyState == 1) {
                    NProgress.start();
                }
                if (realXHR.readyState == 4) {
                    NProgress.done();
                    try {
                        let res = JSON.parse(realXHR.response);
                        if (!res.IsSuccess) {
                            msg.error(res.Message);
                        }
                    } catch { }
                }
            }, false);
            return realXHR;
        }
        window.XMLHttpRequest = newXHR;
    } catch (e) {

    }
});

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

/** Check valid lat-lng */
function isLatLng(lat, lng) {
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


/** Check valid email */
function isEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}


/** Check valid url */
function isValidFriendlyUrl(str) {
    return !/[@~`!#$%\^&*+=\\[\]\\';,/{}|\\":<>\?]/g.test(str);
}
/** Check phone number */
function isPhoneNumber(phone) {
    if (IsNullOrEmpty(phone)) return false;
    phone = phone.replace('(+84)', '0');
    phone = phone.replace('+84', '0');
    phone = phone.replace(/ /g, '');
    var vnf_regex = /((09|03|07|08|05)+([0-9]{8})\b)/g;
    return vnf_regex.test(phone);

}

/** Function convert time to time ago */
function parseTimeAgo(dateString) {
    let date = moment(dateString, 'DD/MM/YYYY HH:mm').toDate();
    var seconds = Math.floor((new Date() - date) / 1000);
    var interval = seconds / 31536000;
    if (interval > 1) {
        return Math.floor(interval) + " năm trước";
    }
    interval = seconds / 2592000;
    if (interval > 1) {
        return Math.floor(interval) + " tháng trước";
    }
    interval = seconds / 86400;
    if (interval > 1) {
        return Math.floor(interval) + " ngày trước";
    }
    interval = seconds / 3600;
    if (interval > 1) {
        return Math.floor(interval) + " giờ trước";
    }
    interval = seconds / 60;
    if (interval > 1) {
        return Math.floor(interval) + " phút trước";
    }
    return Math.floor(seconds) + " giây trước";
}

function getEmptyOrDefault(text) {
    if (!!text)
        return text;
    else return "";
}

/*show modal
 * Element: btn thực hiện action
 action : sự kiện khi bấm btn đồng ý trong modal
 */
function showModal(modal, element = null, action = null) {
    $(modal).modal({ backdrop: 'static' });
    if (action != null && action != undefined) {

        $(element).unbind().on('click', action);
    }
}

/*hide modal*/
function hideModal(modal) {
    $(modal).modal('hide');
}

/*check string is null or empty*/
function IsNullOrEmpty(text) {
    if (text == undefined || text == null || text == undefined || text == NaN) return true;
    if ($.trim(text) == '') return true;
    return false;
}

/*file to object*/
function formToObject(nameForm) {
    let data = $(form).serializeToJSON();
    let obj = {};
    let a = $(nameForm).serializeArray();
    $.each(a, function (index, item) {
        obj[item.name] = item.value;
    });
    return obj;
}

/*file to object*/
function formToObject2(nameForm) {
    let data = $(form).serializeToJSON();
    return data;
}

/*Format money*/
function formatMoney(money) {
    if (money == undefined) return 0;
    return money.toLocaleString('en-AU').replace(/,/g, ',') + 'đ';
}

/** Get start-date and end-date in daterangepicker */
function getDateRangeValue(element) {
    let string = $(element).val();
    let arr = string.split(' - ');
    return {
        startDate: arr[0],
        endDate: arr[1]
    }
}
/*Make url friendly*/
function MakeUrl(str) {
    var AccentsMap = [
        "aàảãáạăằẳẵắặâầẩẫấậ",
        "AÀẢÃÁẠĂẰẲẴẮẶÂẦẨẪẤẬ",
        "dđ", "DĐ",
        "eèẻẽéẹêềểễếệ",
        "EÈẺẼÉẸÊỀỂỄẾỆ",
        "iìỉĩíị",
        "IÌỈĨÍỊ",
        "oòỏõóọôồổỗốộơờởỡớợ",
        "OÒỎÕÓỌÔỒỔỖỐỘƠỜỞỠỚỢ",
        "uùủũúụưừửữứự",
        "UÙỦŨÚỤƯỪỬỮỨỰ",
        "yỳỷỹýỵ",
        "YỲỶỸÝỴ"
    ];
    for (var i = 0; i < AccentsMap.length; i++) {
        var re = new RegExp('[' + AccentsMap[i].substr(1) + ']', 'g');
        var char = AccentsMap[i][0];
        str = str.replace(re, char);
        if (AccentsMap[i] == ' ' && AccentsMap[i + 1] == ' ') {
            AccentsMap[i + 1] = '';
            i = i - 1;
        }
    }
    str = str.replace(/ +(?= )/g, '');
    str = str.replace(/[.,;:'"!@#$%^&*()+_=?|\/`~<>]/g, '');
    str = str.replace(/ /g, '-');
    str = str.replace(/--/g, '-');
    return str.toLowerCase();
}


function removeUnicode(str) {
        var AccentsMap = [
            "aàảãáạăằẳẵắặâầẩẫấậ",
            "AÀẢÃÁẠĂẰẲẴẮẶÂẦẨẪẤẬ",
            "dđ", "DĐ",
            "eèẻẽéẹêềểễếệ",
            "EÈẺẼÉẸÊỀỂỄẾỆ",
            "iìỉĩíị",
            "IÌỈĨÍỊ",
            "oòỏõóọôồổỗốộơờởỡớợ",
            "OÒỎÕÓỌÔỒỔỖỐỘƠỜỞỠỚỢ",
            "uùủũúụưừửữứự",
            "UÙỦŨÚỤƯỪỬỮỨỰ",
            "yỳỷỹýỵ",
            "YỲỶỸÝỴ"
        ];
        for (var i = 0; i < AccentsMap.length; i++) {
            var re = new RegExp('[' + AccentsMap[i].substr(1) + ']', 'g');
            var char = AccentsMap[i][0];
            str = str.replace(re, char);
            if (AccentsMap[i] == ' ' && AccentsMap[i + 1] == ' ') {
                AccentsMap[i + 1] = '';
                i = i - 1;
            }
        }
        return str.toLowerCase();
}