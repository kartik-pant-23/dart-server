import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

void main() async {
  // Show packages cards
  var cardsList = querySelector('#cards');
  List packages = await getPackages(document.baseUri.split('=')[1] ?? '');
  if (packages != null) {
    packages.forEach((htmlElement) {
      LIElement card = LIElement();
      card.children.add(htmlElement);
      cardsList.children.add(card);
    });
  }

  // Download packages.json
  querySelector('#download').onClick.listen((event) async {
    try {
      window.location.href = 'http://localhost:4000/api/packages/download';
    } catch (e) {
      window.console.log(e.toString());
    }
  });
}

Future<List> getPackages(String query) async {
  try {
    Uri getPackages =
        Uri.parse('http://localhost:4000/api/packages/?name=$query');
    var response = await http.get(getPackages);
    List result = [];
    for (final item in json.decode(response.body)) {
      window.console.log(item);
      var name = item['name'], metadata = item['metadata'];
      var div = new Element.div()..className = 'card';
      var a = new Element.a()
        ..attributes = {'href': 'https://pub.dev/packages/$name'}
        ..innerText = name;
      var p = new Element.p()..innerText = metadata;
      div.children..add(a)..add(p);
      result.add(div);
    }
    return result;
  } catch (e) {
    window.console.log(e.toString());
    return null;
  }
}
