import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

void main() async {
  var email = querySelector('#email') as InputElement;
  var password = querySelector('#pwd') as InputElement;

  document.getElementById('submit').onClick.listen((event) async {
    querySelector('#response-text').text =
        await postLoginDetails(email.value, password.value);
    email.value = '';
    password.value = '';
  });
}

Future<String> postLoginDetails(String email, String password) async {
  try {
    Uri uri = Uri.parse('http://localhost:4000/users/login');
    var response = await http.post(uri,
        body: json.encode({"email": email, "password": password}));
    return response.body;
  } catch (e) {
    return e.toString();
  }
}
