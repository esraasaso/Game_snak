import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home:  const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List <int> snakePosition=[42,62,82,102];
  int numberSquare=768;
   static var randomNumber =Random();
   int food =randomNumber.nextInt(700);
   var speed=500;
   bool playing =false;
   var direction ="down";
   bool x1=false;
   bool x2=false;
   bool x3=false;
   bool endGame=false;
  @override
  Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.grey,
  body: Column(
    children: [
      Expanded(child:
      GestureDetector(
        onVerticalDragUpdate: (details) {
          if (direction != 'up' && details.delta.dy > 0) {
            direction = 'down';
          } else if (direction != 'down' && details.delta.dy < 0) {
            direction = 'up';
          }
        },
        onHorizontalDragUpdate: (details) {
          if (direction != 'left' && details.delta.dx > 0) {
            direction = 'right';
          } else if (direction != 'right' && details.delta.dx < 0) {
            direction = 'left';
          }
        },
        child: Stack(
          children: [
             Center(
                child: Image.asset("images/snakk.jpg")
            ),
            GridView.builder(
                itemCount: numberSquare,
                physics:const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20),
                itemBuilder:(
          BuildContext ctx,int index)
{
  if(snakePosition.contains(index)) {
                    return  Center(
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  if(index==food){
                return Container(
                padding:const EdgeInsets.all(2),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:const Center(
                child:Icon(Icons.fastfood,size: 20,color: Colors.yellow,)
                ),
                ),
                );
                }
                  return   Container(
                    padding:const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  );
                }
                )
          ],
        ),
      )
      ),!playing?Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: x1?Colors.red:Colors.transparent,
    ),
    margin:const EdgeInsets.all(10),
    child: TextButton(
      onPressed: (){
       setState(() {
         x1=true;
         x2=false;
         x3=false;
       }); 
      }, child:const Text("x1",style: TextStyle(color: Colors.white)),
      
    ),
  ),
  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: x2?Colors.red:Colors.transparent,
    ),
    margin:const EdgeInsets.all(10),
    child: TextButton(
      onPressed: (){
        setState(() {
          x1=false;
          x2=true;
          x3=false;
          speed=500;
        });
      }, child:const Text("x2",style: TextStyle(color: Colors.white)),

    ),
  ),
  Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: x3?Colors.red:Colors.transparent,
    ),
    margin:const EdgeInsets.all(10),
    child: TextButton(
      onPressed: (){
        setState(() {
          x1=false;
          x2=false;
          x3=true;
          speed=700;
        });
      }, child:const Text("x3",style: TextStyle(color: Colors.white)),

    ),
  ),
  OutlinedButton(
      onPressed: (){
      startGame();
      },
      child:Row(children:const [
        Text("start",style: TextStyle(color: Colors.white)),
        SizedBox(width: 5,),
        Icon(Icons.play_arrow,color: Colors.yellow,)
      ]
      ),

    ),
],
      ):Container(
        height: 58,
        color: Colors.white70,
        child: Center(
          child: OutlinedButton(onPressed: (){
            setState(() {
              endGame=true;
            });
          }, child:const Text(
            "End the game and show result",
          )),
        ),
      )
    ],
  ),
);
  }
  startGame(){
    setState(() {
      playing=true;
    });
    endGame=false;
    snakePosition=[42,62,102];
    var duration = Duration(milliseconds: speed);
    Timer.periodic(duration, (Timer timer)
    {
      updatesnake();
      if(gameOver()||endGame){
        timer.cancel();
        showGameOverDialog();
        playing=false;
        x1=false;
        x2=false;
        x3=false;
      }
    });
  }
  gameOver(){
    for(int i=0;i<snakePosition.length;i++){
      int count=0;
      for(int j=0;j<snakePosition.length;j++){
        if(snakePosition[i]==snakePosition[j]){
          count+=1;
        }
        if(count==2){
          setState(() {
            playing=false;
          });
          return true;
        }
      }
      return false;
    }
  }
  showGameOverDialog(){
    showDialog(context: context, builder:(BuildContext context){
      return AlertDialog(
        title: const Text("Game over"),
        content: Text("your score is"+snakePosition.length.toString()),
        actions: [
          TextButton(onPressed: (){
            startGame();
            Navigator.of(context).pop(true);
          }, child: const Text("Play again"))
        ],
      );
    });
  }
  generateNewFood(){
    food=randomNumber.nextInt(700);
  }
  updatesnake(){
      setState(() {
        switch (direction) {
          case 'down':
            if (snakePosition.last > 740) {
              snakePosition.add(snakePosition.last + 20 - 760);
            } else {
              snakePosition.add(snakePosition.last + 20);
            }
            break;
          case 'up':
            if (snakePosition.last < 20) {
              snakePosition.add(snakePosition.last - 20 + 760);
            } else {
              snakePosition.add(snakePosition.last - 20);
            }
            break;
          case 'left':
            if (snakePosition.last % 20 == 0) {
              snakePosition.add(snakePosition.last - 1 + 20);
            } else {
              snakePosition.add(snakePosition.last - 1);
            }
            break;
          case 'right':
            if ((snakePosition.last + 1) % 20 == 0) {
              snakePosition.add(snakePosition.last + 1 - 20);
            } else {
              snakePosition.add(snakePosition.last + 1);
            }
            break;
          default:
        }
        if (snakePosition.last == food) {
          generateNewFood();
        } else {
          snakePosition.removeAt(0);
        }
      });
  }
  }
