import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;

Map<String, List<String>> provinces = {};

Map<String, List<String>> districts = {};

void load() {
  for (int i = 0; i < dvhcvn.level1s.length; i++) {
    List<String> pros = [];
    for (int k = 0; k < dvhcvn.level1s[i].children.length; k++) {
      List<String> diss = [];
      pros.add(dvhcvn.level1s[i].children[k].name);
      for (int j = 0; j < dvhcvn.level1s[i].children[k].children.length; j++) {
        diss.add(dvhcvn.level1s[i].children[k].children[j].name);
      }
      districts[dvhcvn.level1s[i].children[k].name] = diss;
    }
    provinces[dvhcvn.level1s[i].name] = pros;
  }
}
