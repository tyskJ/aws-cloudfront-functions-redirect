function handler(event) {
  var request = event.request;
  var uri = request.uri;
  var headers = request.headers;
  var host = request.headers.host.value;
  var newurl = `https://${FqdnForAlb}/`;

  // Check uri
  if (uri == "/test1/") {
    newurl = `https://${FqdnForAlb}/test1/`;
  }
  // Check uri
  else if (uri == "/test2/") {
    newurl = `https://${FqdnForAlb}/test2/`;
  } else {
    return request;
  }
  var response = {
    status: "301",
    statusDescription: "Moved Permanently",
    headers: {
      location: {
        value: newurl,
      },
    },
  };
  return response;
}
