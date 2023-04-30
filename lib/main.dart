import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:turkish/turkish.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'box.dart' as b;
import 'gameoverscreen.dart' as gos;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

late List<int> listeee = [];

class _MyHomePageState extends State<MyHomePage> {
  String metin = '';

  bool cont = false;
  int three_false_kontol = 0;
  String inner = '';
  List<int> indexes = [];
  List<int> random_list =
      List.generate(80, (index) => math.Random().nextInt(29));
  List<double> random_colors =
      List.generate(80, (index) => math.Random().nextDouble() * 0xFFFFFF);
  List<b.Box> grid = [];
  int puan = 0;
  bool timer_kontrol = false;
  List<int> frozen_indexes = [];
  List letters = [
    'A',
    'B',
    'C',
    'Ç',
    'D',
    'E',
    'F',
    'G',
    'Ğ',
    'H',
    'I',
    'İ',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'Ö',
    'P',
    'R',
    'S',
    'Ş',
    'T',
    'U',
    'Ü',
    'V',
    'Y',
    'Z'
  ];
  List sesli_harfler = [
    'A',
    'E',
    'I',
    'İ',
    'O',
    'Ö',
    'U',
    'Ü',
  ];
  List sessiz_harfler = [
    'B',
    'C',
    'Ç',
    'D',
    'F',
    'G',
    'Ğ',
    'H',
    'J',
    'K',
    'L',
    'M',
    'N',
    'P',
    'R',
    'S',
    'Ş',
    'T',
    'V',
    'Y',
    'Z'
  ];
  word_to_lowercase(String kelime) {
    String word = "";
    for (var i in kelime.split("")) {
      if (i == "I") {
        word = word + "ı";
      } else if (i == "İ") {
        word = word + "i";
      } else {
        word = word + i.toLowerCase();
      }
    }
    return word;
  }

  get_words(String kelime) async {
    print(frozen_indexes);
    var response = '';
    List<int> frozens = [];
    var grid2 = grid;
    response = await rootBundle.loadString('lib/klist.txt');
    List<String> response2 = response.split(',');
    setState(() {
      cont = response2.contains(word_to_lowercase(kelime));
      indexes.sort((a, b) => a.compareTo(b));
      if (cont) {
        for (var i in indexes) {
          if (!grid2[i].isFrozen) {
            for (var j = i; j > 8; j = j - 8) {
              double rad = 10;
              if (sesli_harfler.contains(grid2[j].harf)) {
                rad = 25;
              }
              if (grid2[j].harf != "" && grid2[j - 8].harf != "") {
                grid2[j].harf = grid2[j - 8].harf;
                grid2[j].renk = grid2[j - 8].renk;
                if (grid2[j - 8].isFrozen) {
                  grid2[j].isFrozen = grid2[j - 8].isFrozen;
                  grid2[j - 8].isFrozen = false;
                  grid2[j].konteyner = Container(
                    decoration: BoxDecoration(
                        color: Color(grid2[j].renk.toInt()).withOpacity(1.0),
                        borderRadius: BorderRadius.all(Radius.circular(rad))),
                    child: TextButton(
                      child: Stack(children: [
                        const Icon(Icons.ac_unit_rounded,
                            color: Colors.white, size: 50),
                        Text(
                          grid[j].harf,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        )
                      ]),
                      onPressed: () => {get_inner(grid2[j].harf, j)},
                    ),
                  );
                } else {
                  grid2[j].konteyner = Container(
                    decoration: BoxDecoration(
                        color: Color(grid2[j].renk.toInt()).withOpacity(1.0),
                        borderRadius: BorderRadius.all(Radius.circular(rad))),
                    child: TextButton(
                      child: Text(
                        grid2[j].harf,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onPressed: () => {get_inner(grid2[j].harf, j)},
                    ),
                  );
                }
              } else {
                grid2[j].harf = "";
                grid2[j].konteyner = Container(
                  decoration: BoxDecoration(
                      color: Color(grid2[j].renk.toInt()).withOpacity(0.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () => {},
                  ),
                );
              }
            }

            grid2[i % 8].harf = "";
            grid2[i % 8].konteyner = Container(
              decoration: BoxDecoration(
                  color: Color(grid2[i % 8].renk.toInt()).withOpacity(0.0),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextButton(
                child: Text(
                  "",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                onPressed: () => {},
              ),
            );
          } else {
            grid2[i].isFrozen = false;
            frozens.add(i);
            frozen_indexes.remove(i);
          }
        }
        puan_hesapla(inner);
        inner = '';
        indexes = [];
        grid = grid2;
        for (var i in frozens) {
          not_clicked(i);
        }
      } else {
        three_false_kontol++;
        del_all();
      }
      if (three_false_kontol == 3) {
        three_false_kontol = 0;
        third_wrong();
      }
    });
  }

  del_all() {
    for (var i in indexes) {
      not_clicked(i);
    }
    inner = '';
    indexes = [];
  }

  get_inner(str, index) {
    setState(() {
      if (!(indexes.contains(index))) {
        inner += str;
        indexes.add(index);
        clicked(index);
      } else {
        inner = inner.substring(0, indexes.indexOf(index)) +
            inner.substring(indexes.indexOf(index) + 1);
        indexes.remove(index);
        not_clicked(index);
      }
    });
  }

  drop_tile() async {
    int random_number = math.Random().nextInt(8);
    int ran_col = math.Random().nextInt(80);
    if (grid[random_number].harf == "") {
      if (math.Random().nextInt(1000) <= 900) {
        String harf = letters[math.Random().nextInt(29)];
        double rad = 10;
        if (sesli_harfler.contains(harf)) {
          rad = 25;
        }

        grid[random_number].harf = harf;
        grid[random_number].renk = random_colors[ran_col];
        grid[random_number].konteyner = Container(
          decoration: BoxDecoration(
              color: Color(grid[random_number].renk.toInt()).withOpacity(1.0),
              borderRadius: BorderRadius.all(Radius.circular(rad))),
          child: TextButton(
            child: Text(
              grid[random_number].harf,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () =>
                {get_inner(grid[random_number].harf, random_number)},
          ),
        );
        for (int i = random_number; i < 72; i = i + 8) {
          await Future.delayed(Duration(milliseconds: 60), () {
            setState(() {
              if (!letters.contains(grid[i + 8].harf)) {
                grid[i + 8].harf = grid[i].harf;
                grid[i + 8].renk = grid[i].renk;
                grid[i + 8].konteyner = Container(
                  decoration: BoxDecoration(
                      color: Color(grid[i].renk.toInt()).withOpacity(1.0),
                      borderRadius: BorderRadius.all(Radius.circular(rad))),
                  child: TextButton(
                    child: Text(
                      grid[i + 8].harf,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () => {get_inner(grid[i + 8].harf, i + 8)},
                  ),
                );
                grid[i].harf = "";
                grid[i].konteyner = Container(
                  decoration: BoxDecoration(
                      color: Color(grid[i].renk.toInt()).withOpacity(0.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () => {},
                  ),
                );
              }
            });
          });
        }
      } else {
        String harf = letters[math.Random().nextInt(29)];
        for (int x = random_number; x < 80; x += 8) {
          if (letters.contains(grid[x].harf)) {
            frozen_indexes.add(x - 8);
            break;
          }
        }
        double rad = 10;
        if (sesli_harfler.contains(harf)) {
          rad = 25;
        }
        grid[random_number].isFrozen = true;
        grid[random_number].harf = harf;
        grid[random_number].renk = random_colors[ran_col];
        grid[random_number].konteyner = Container(
          decoration: BoxDecoration(
              color: Color(grid[random_number].renk.toInt()).withOpacity(1.0),
              borderRadius: BorderRadius.all(Radius.circular(rad))),
          child: TextButton(
            child: Stack(children: [
              const Icon(Icons.ac_unit_rounded, color: Colors.white, size: 50),
              Text(
                grid[random_number].harf,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ]),
            onPressed: () =>
                {get_inner(grid[random_number].harf, random_number)},
          ),
        );
        for (int i = random_number; i < 72; i = i + 8) {
          await Future.delayed(Duration(milliseconds: 60), () {
            setState(() {
              if (!letters.contains(grid[i + 8].harf)) {
                grid[i + 8].isFrozen = grid[i].isFrozen;
                grid[i + 8].harf = grid[i].harf;
                grid[i + 8].renk = grid[i].renk;
                grid[i + 8].konteyner = Container(
                  decoration: BoxDecoration(
                      color: Color(grid[i].renk.toInt()).withOpacity(1.0),
                      borderRadius: BorderRadius.all(Radius.circular(rad))),
                  child: TextButton(
                    child: Stack(children: [
                      const Icon(Icons.ac_unit_rounded,
                          color: Colors.white, size: 50),
                      Text(
                        grid[i + 8].harf,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      )
                    ]),
                    onPressed: () => {get_inner(grid[i + 8].harf, i + 8)},
                  ),
                );
                grid[i].isFrozen = false;
                grid[i].harf = "";
                grid[i].konteyner = Container(
                  decoration: BoxDecoration(
                      color: Color(grid[i].renk.toInt()).withOpacity(0.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () => {},
                  ),
                );
              }
            });
          });
        }
        start_freezing();
      }
    } else {
      sec = 0;
      timer_kontrol = true;
    }
  }

  start_freezing() async {
    Timer mytimer3 = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (frozen_indexes.length > 0) {
        for (var i in frozen_indexes) {
          List<int> liste = [i - 1, i + 1, i - 8, i + 8];

          if (i - 1 > 0 && i - 1 < 80 && i - 1 % 8 != 7) {
            if (grid[i - 1].isFrozen == false &&
                letters.contains(grid[i - 1].harf)) {
              grid[i - 1].isFrozen = true;
              not_clicked(i - 1);
            }
          }
          if (i + 1 > 0 && i + 1 < 80 && i + 1 % 8 != 0) {
            if (grid[i + 1].isFrozen == false &&
                letters.contains(grid[i + 1].harf)) {
              grid[i + 1].isFrozen = true;
              not_clicked(i + 1);
            }
          }
          if (i - 8 > 0 && i - 8 < 80) {
            if (grid[i - 8].isFrozen == false &&
                letters.contains(grid[i - 8].harf)) {
              grid[i - 8].isFrozen = true;
              not_clicked(i - 8);
            }
          }
          if (i + 8 > 0 && i + 8 < 80) {
            if (grid[i + 8].isFrozen == false &&
                letters.contains(grid[i + 8].harf)) {
              grid[i + 8].isFrozen = true;
              not_clicked(i + 8);
            }
          }
        }
      } else {
        timer.cancel();
      }
    });
  }

  clicked(index) async {
    setState(() {
      double rad = 10;
      if (sesli_harfler.contains(grid[index].harf)) {
        rad = 25;
      }
      if (grid[index].isFrozen) {
        grid[index].konteyner = Container(
          decoration: BoxDecoration(
              color: Color(grid[index].renk.toInt())
                  .withOpacity(1.0)
                  .withAlpha(128),
              borderRadius: BorderRadius.all(Radius.circular(rad))),
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rad),
                  side: BorderSide(
                      width: 3,
                      color: Color(grid[index].renk.toInt()).withOpacity(1.0)),
                ),
              ),
            ),
            child: Stack(children: [
              const Icon(Icons.ac_unit_rounded, color: Colors.white, size: 50),
              Text(
                grid[index].harf,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ]),
            onPressed: () => {get_inner(grid[index].harf, index)},
          ),
        );
      } else {
        grid[index].konteyner = Container(
          decoration: BoxDecoration(
              color: Color(grid[index].renk.toInt())
                  .withOpacity(1.0)
                  .withAlpha(128),
              borderRadius: BorderRadius.all(Radius.circular(rad))),
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rad),
                  side: BorderSide(
                      width: 3,
                      color: Color(grid[index].renk.toInt()).withOpacity(1.0)),
                ),
              ),
            ),
            child: Text(
              grid[index].harf,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            onPressed: () => {get_inner(grid[index].harf, index)},
          ),
        );
      }
    });
  }

  not_clicked(index) {
    setState(() {
      double rad = 10;
      if (sesli_harfler.contains(grid[index].harf)) {
        rad = 25;
      }
      if (grid[index].isFrozen) {
        grid[index].konteyner = Container(
          decoration: BoxDecoration(
              color: Color(grid[index].renk.toInt()).withOpacity(1.0),
              borderRadius: BorderRadius.all(Radius.circular(rad))),
          child: TextButton(
            child: Stack(children: [
              const Icon(Icons.ac_unit_rounded, color: Colors.white, size: 50),
              Text(
                grid[index].harf,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ]),
            onPressed: () => {get_inner(grid[index].harf, index)},
          ),
        );
      } else {
        grid[index].konteyner = Container(
          decoration: BoxDecoration(
              color: Color(grid[index].renk.toInt()).withOpacity(1.0),
              borderRadius: BorderRadius.all(Radius.circular(rad))),
          child: TextButton(
            child: Text(
              grid[index].harf,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () => {get_inner(grid[index].harf, index)},
          ),
        );
      }
    });
  }

  calculate_letter_points(String Kelime) {
    dynamic sumPoint = 0;
    final splitted = Kelime.split("");

    Map<String, int> letter_Points = {
      'A': 1,
      'B': 3,
      'C': 4,
      'Ç': 4,
      'D': 3,
      'E': 1,
      'F': 7,
      'G': 5,
      'Ğ': 8,
      'H': 5,
      'I': 2,
      'İ': 1,
      'J': 10,
      'K': 1,
      'L': 1,
      'M': 2,
      'N': 1,
      'O': 2,
      'Ö': 7,
      'P': 5,
      'R': 1,
      'S': 2,
      'Ş': 4,
      'T': 1,
      'U': 2,
      'Ü': 3,
      'V': 7,
      'Y': 3,
      'Z': 4
    };

    for (var element in splitted) {
      if (letter_Points.containsKey(element)) {
        sumPoint += letter_Points[element];
      }
    }
    return sumPoint;
  }

  puan_hesapla(kelime) {
    setState(() {
      puan += int.parse(calculate_letter_points(kelime).toString());
    });
  }

  third_wrong() async {
    for (int a = 0; a < 8; a++) {
      if (grid[a].harf == "") {
        String harf = letters[math.Random().nextInt(29)];
        double rad = 10;
        if (sesli_harfler.contains(harf)) {
          rad = 25;
        }
        grid[a].harf = harf;
        grid[a].renk = random_colors[math.Random().nextInt(80)];
        grid[a].konteyner = Container(
          decoration: BoxDecoration(
              color: Color(grid[a].renk.toInt()).withOpacity(1.0),
              borderRadius: BorderRadius.all(Radius.circular(rad))),
          child: TextButton(
            child: Text(
              grid[a].harf,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () => {get_inner(grid[a].harf, a)},
          ),
        );
      } else {
        sec = 0;
        timer_kontrol = true;
      }
    }
    for (int j = 7; j < 71; j = j + 8) {
      await Future.delayed(Duration(milliseconds: 60), () {
        for (int i = j; i >= j - 7; i--) {
          double rad = 10;
          if (sesli_harfler.contains(grid[i + 8].harf)) {
            rad = 25;
          }
          setState(() {
            if (grid[i + 8].harf == "") {
              if (!letters.contains(grid[i + 8].harf)) {
                grid[i + 8].harf = grid[i].harf;
                grid[i + 8].renk = grid[i].renk;
                grid[i + 8].konteyner = Container(
                  decoration: BoxDecoration(
                      color: Color(grid[i].renk.toInt()).withOpacity(1.0),
                      borderRadius: BorderRadius.all(Radius.circular(rad))),
                  child: TextButton(
                    child: Text(
                      grid[i + 8].harf,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () => {get_inner(grid[i + 8].harf, i + 8)},
                  ),
                );
                grid[i].harf = "";
                grid[i].konteyner = Container(
                  decoration: BoxDecoration(
                      color: Color(grid[i].renk.toInt()).withOpacity(0.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () => {},
                  ),
                );
              }
            }
          });
        }
      });
    }
  }

  set_grid() async {
    setState(() {
      grid = List.generate(
          80,
          (index) => b.Box(
              '',
              random_colors[index],
              Container(
                decoration: BoxDecoration(
                    color: Color(random_colors[index].toInt()).withOpacity(0.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextButton(
                  child: Text(
                    '',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  onPressed: () => {},
                ),
              )));
    });
    for (int m = 0; m < 3; m++) {
      for (int a = 0; a < 8; a++) {
        String harf = letters[math.Random().nextInt(29)];
        double rad;
        if (sesli_harfler.contains(grid[a].harf)) {
          rad = 25;
        } else {
          rad = 10;
        }
        grid[a].harf = harf;
        grid[a].renk = random_colors[math.Random().nextInt(80)];
        grid[a].konteyner = Container(
          decoration: BoxDecoration(
              color: Color(grid[a].renk.toInt()).withOpacity(1.0),
              borderRadius: BorderRadius.all(Radius.circular(rad))),
          child: TextButton(
            child: Text(
              grid[a].harf,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () => {get_inner(grid[a].harf, a)},
          ),
        );
      }

      for (int j = 7; j < 72; j = j + 8) {
        await Future.delayed(Duration(milliseconds: 10), () {
          for (int i = j; i >= j - 7; i--) {
            double rad;
            if (sesli_harfler.contains(grid[i].harf)) {
              rad = 25;
            } else {
              rad = 10;
            }
            setState(() {
              if (grid[i + 8].harf == "") {
                if (!letters.contains(grid[i + 8].harf)) {
                  grid[i + 8].harf = grid[i].harf;
                  grid[i + 8].renk = grid[i].renk;
                  grid[i + 8].konteyner = Container(
                    decoration: BoxDecoration(
                        color: Color(grid[i].renk.toInt()).withOpacity(1.0),
                        borderRadius: BorderRadius.all(Radius.circular(rad))),
                    child: TextButton(
                      child: Text(
                        grid[i + 8].harf,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () => {get_inner(grid[i + 8].harf, i + 8)},
                    ),
                  );
                  grid[i].harf = "";
                  grid[i].konteyner = Container(
                    decoration: BoxDecoration(
                        color: Color(grid[i].renk.toInt()).withOpacity(0.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onPressed: () => {},
                    ),
                  );
                }
              }
            });
          }
        });
      }
      ;
    }
  }

  int sec = 8;
  int kontrol = 0;
  @override
  initState() {
    Timer mytimer = Timer.periodic(Duration(seconds: sec), (Timer timer) async {
      kontrol++;
      if (kontrol == 0) {
        sec = 5;
      }
      if (timer_kontrol) {
        SharedPreferences pre = await SharedPreferences.getInstance();
        pre.setString(
            "puan", pre.getString("puan").toString() + puan.toString() + ",");
        gos.read_file();
        buton.onPressed!();
        timer.cancel();
      } else {
        drop_tile();
      }
      if (puan >= 10) {
        sec = 4;
      } else if (puan >= 200) {
        sec = 3;
      } else if (puan >= 300) {
        sec = 2;
      } else if (puan >= 400) {
        sec = 1;
      }
    });
  }

  TextButton buton = TextButton(onPressed: () {}, child: Text('TextButton'));

  var kont = 0;
  @override
  Widget build(BuildContext context) {
    buton = TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return gos.Gameoverscreen();
          }));
        },
        child: Text('TextButton'));
    if (kont == 0) {
      kont++;
      set_grid();
    }
    final myController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Visibility(
            child: buton,
            visible: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
            child: Container(
              child: GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    crossAxisCount: 8,
                  ),
                  children: [
                    grid[0].konteyner,
                    grid[1].konteyner,
                    grid[2].konteyner,
                    grid[3].konteyner,
                    grid[4].konteyner,
                    grid[5].konteyner,
                    grid[6].konteyner,
                    grid[7].konteyner,
                    grid[8].konteyner,
                    grid[9].konteyner,
                    grid[10].konteyner,
                    grid[11].konteyner,
                    grid[12].konteyner,
                    grid[13].konteyner,
                    grid[14].konteyner,
                    grid[15].konteyner,
                    grid[16].konteyner,
                    grid[17].konteyner,
                    grid[18].konteyner,
                    grid[19].konteyner,
                    grid[20].konteyner,
                    grid[21].konteyner,
                    grid[22].konteyner,
                    grid[23].konteyner,
                    grid[24].konteyner,
                    grid[25].konteyner,
                    grid[26].konteyner,
                    grid[27].konteyner,
                    grid[28].konteyner,
                    grid[29].konteyner,
                    grid[30].konteyner,
                    grid[31].konteyner,
                    grid[32].konteyner,
                    grid[33].konteyner,
                    grid[34].konteyner,
                    grid[35].konteyner,
                    grid[36].konteyner,
                    grid[37].konteyner,
                    grid[38].konteyner,
                    grid[39].konteyner,
                    grid[40].konteyner,
                    grid[41].konteyner,
                    grid[42].konteyner,
                    grid[43].konteyner,
                    grid[44].konteyner,
                    grid[45].konteyner,
                    grid[46].konteyner,
                    grid[47].konteyner,
                    grid[48].konteyner,
                    grid[49].konteyner,
                    grid[50].konteyner,
                    grid[51].konteyner,
                    grid[52].konteyner,
                    grid[53].konteyner,
                    grid[54].konteyner,
                    grid[55].konteyner,
                    grid[56].konteyner,
                    grid[57].konteyner,
                    grid[58].konteyner,
                    grid[59].konteyner,
                    grid[60].konteyner,
                    grid[61].konteyner,
                    grid[62].konteyner,
                    grid[63].konteyner,
                    grid[64].konteyner,
                    grid[65].konteyner,
                    grid[66].konteyner,
                    grid[67].konteyner,
                    grid[68].konteyner,
                    grid[69].konteyner,
                    grid[70].konteyner,
                    grid[71].konteyner,
                    grid[72].konteyner,
                    grid[73].konteyner,
                    grid[74].konteyner,
                    grid[75].konteyner,
                    grid[76].konteyner,
                    grid[77].konteyner,
                    grid[78].konteyner,
                    grid[79].konteyner
                  ]),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 40, left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Colors.red,
                      onPressed: () => {del_all()},
                      child: const Icon(Icons.cancel)),
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: inner,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Colors.green,
                      onPressed: () => get_words(inner),
                      child: const Icon(Icons.done)),
                ],
              )),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                "Puan: " + puan.toString(),
                style: TextStyle(color: Colors.black, fontSize: 20),
              ))
        ]),
      ),
    );
  }
}
