.pragma library

WorkerScript.onMessage = function(message) {
    var xhr = new XMLHttpRequest;
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            WorkerScript.sendMessage({ method: message.method,
                                       response: xhr.responseText,
                                       id: message.id })
        }
    }
    xhr.open("GET", message.url);
    xhr.send();
}
