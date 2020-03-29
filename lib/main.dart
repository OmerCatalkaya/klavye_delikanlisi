import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = "";

  String lorem_tr =
      "                                                   Lorem Ipsum, dizgi ve baskı endüstrisinde kullanılan mıgır metinlerdir. Lorem Ipsum, adı bilinmeyen bir matbaacının bir hurufat numune kitabı oluşturmak üzere bir yazı galerisini alarak karıştırdığı 1500'lerden beri endüstri standardı sahte metinler olarak kullanılmıştır. Beşyüz yıl boyunca varlığını sürdürmekle kalmamış, aynı zamanda pek değişmeden elektronik dizgiye de sıçramıştır. 1960'larda Lorem Ipsum pasajları da içeren Letraset yapraklarının yayınlanması ile ve yakın zamanda Aldus PageMaker gibi Lorem Ipsum sürümleri içeren masaüstü yayıncılık yazılımları ile popüler olmuştur."
          .toLowerCase()
          .replaceAll(",", "")
          .replaceAll(".", "");
  String lorem =
      "                                                   Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
          .toLowerCase()
          .replaceAll(",", "")
          .replaceAll(".", "");

  int step = 0;
  int typeCharLenght = 0;
  int lastTypeAt;

  void resetGame() {
    setState(() {
      step = 0;
      typeCharLenght = 0;
    });
  }

  void updateLastTypeAt() {
    this.lastTypeAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypeAt();
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        typeCharLenght += 1;
      }
    });
  }

  void onUserNameType(String value) {
    setState(() {
      this.userName = value;  
    });
    
  }

  void onStartClick() {
    setState(() {
      updateLastTypeAt();
      step++;
    });

    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      // Game Over
      setState(() {
        if (step == 1 && now - lastTypeAt > 4000) {
          step++;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;

    if (step == 0) {
      shownWidget = <Widget>[
        Text('Oyuna hoşgeldin, coronadan kaçmaya hazır mısın?'),
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            onChanged: onUserNameType,
            keyboardType: TextInputType.text,
            autocorrect: false,
            obscureText: false,
            maxLength: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Ismin nedir klavye delikanlısı?",
            ),
          ),
        ),
        RaisedButton(
          child: Text("BAŞLA"),
          onPressed: userName.length == 0 ? null : onStartClick,
        )
      ];
    } else if (step == 1) {
      shownWidget = <Widget>[
        Text('$typeCharLenght'),
        Container(
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.end,
            blankSpace: 20.0,
            velocity: 125,
            startPadding: 0,
            //pauseAfterRound: Duration(seconds: 20),
            accelerationDuration: Duration(seconds: 35),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.linear,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: TextField(
            onChanged: onType,
            keyboardType: TextInputType.text,
            autocorrect: false,
            autofocus: true,
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Yaz bakalım",
            ),
          ),
        )
      ];
    } else {
      shownWidget = <Widget>[
        Text('Coronadan kaçamadın. skorun:$typeCharLenght'),
        RaisedButton(child: Text("Yeniden Dene"), onPressed: resetGame)
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Klavye Delikanlısı..."),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}
