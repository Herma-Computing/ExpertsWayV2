import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => QuizState();
}

class QuizState extends State<Quiz> {
  Widget _container(quizs) {
    return Container(
      height: 50,
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15), // set the radius of the edges
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(quizs),
          const SizedBox(width: 35),
          Checkbox(
            value: false,
            onChanged: (value) => true,
            shape: const CircleBorder(),
            activeColor: Colors.black,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: 230,
                  height: 15,
                  child: const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: 0.7,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 42, 135, 240)),
                      backgroundColor: Color(0xffD6D6D6),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 60),
                        height: 172,
                        width: 290,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // set the radius of the edges
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: const [
                            Text(
                                '\n\n\nWhat is will be The output of the \n       following code snippet?'),
                            Image(
                              image: AssetImage('assets/images/Capture.PNG'),
                              width: 210,
                              height: 90,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 75, top: 5),
                      width: 140,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.lightBlue,
                          width: 5,
                        ),
                        color: Colors.white,
                      ),
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.lightBlue,
                        child: Text(
                          '1:39',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                _container('node is an element body!'),
                const SizedBox(
                  height: 30,
                ),
                _container('Textual is an element node!'),
                const SizedBox(
                  height: 30,
                ),
                _container('Body is an textual node!      '),
                const SizedBox(
                  height: 30,
                ),
                _container('Body is an element node!   '),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 40),
                          backgroundColor: Colors.white,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          side: const BorderSide(color: Colors.lightBlue)),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 40),
                        elevation: 1,
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF0077C2), Color(0xFF6EC5FF)],
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 120, minHeight: 40),
                          alignment: Alignment.center,
                          child: const Text('Next',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
