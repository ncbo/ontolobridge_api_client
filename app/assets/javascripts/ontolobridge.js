function ajaxCall(formId, respContainerDivId, respDivId, errDivId, loadingDivId, method, action) {
  clearResults(respDivId, errDivId);
  $('#' + respContainerDivId).show();
  $('#' + loadingDivId).show();
  var params = $("#" + formId).serialize();

  $.ajax({
    method: method,
    url: "/" + action,
    data: params,
    dataType: "json",
    success: function (data) {
      if (data) {
        if (data.error) {
          showError(errDivId, data.error, data);
        } else {
          showSuccess(respDivId, data);
        }
      } else {
        showError(errDivId, "Request successful, but no data has been returned.");
      }
    },
    error: function(request, textStatus, errorThrown) {
      showError(errDivId, request.status + ": " + errorThrown);
    },
    complete: function(request, textStatus) {
      $('#' + loadingDivId).hide();
    }
  });
}

function showSuccess(respDivId, data) {
  var container;

  for (var key in data) {
    container = $('<span class="container_info"></span>');
    $("#" + respDivId).append(container);
    container.append('<span class="key">' + key + ':</span>');
    var val = data[key];

    if (isUrlValid(val)) {
      container.append('<span class="val"><a href="' + val + '" target="_blank">' + val + '</a></span>');
    } else {
      container.append('<span class="val">' + val + '</span>');
    }
  }
  $("#" + respDivId).show();
}

function showError(errDivId, errMsg, data) {
  var container;

  if (data) {
    if (data.error === errMsg) {
      delete data.error;
    }

    for (var key in data) {
      container = $('<span class="container_err"></span>');
      $("#" + errDivId).append(container);
      container.append('<span class="key">' + key + ':</span>');
      container.append('<span class="val">' + data[key] + '</span>');
    }
  }

  container = $('<span class="container_err"></span>');
  $("#" + errDivId).append(container);
  container.append('<span class="key">Error:</span>');
  container.append('<span class="val">' + errMsg + '</span>');
  $("#" + errDivId).show();
}

function clearResults(respDivId, errDivId) {
  $("#" + respDivId).hide();
  $("#" + errDivId).hide();
  $("#" + respDivId).html("");
  $("#" + errDivId).html("");
}

function isUrlValid(url) {
  return /^(https?|s?ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(url);
}

$(document).ready(function () {
  $("#term-status-form").on("submit", function () {
    ajaxCall("term-status-form", "term-status-resp-container", "term-status-resp", "term-status-err", "term-status-loading", "post", "term_status");
    return false;
  });

  $("#request-term-form").on("submit", function () {
    ajaxCall("request-term-form", "request-term-resp-container", "request-term-resp", "request-term-err", "request-term-loading", "post", "request_term");
    return false;
  });
});
