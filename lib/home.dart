import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  final baseurl = "https://opentdb.com/api.php?amount=10";
  String _question = "loading..";
  String _Canswer = "loading..";
  String _Ranswer= "loading..";
  String _Ranswer1= "loading..";
  String _Ranswer2= "loading..";
 

  
  
  var i=0;
  var k=0;

  void _doGet() {    
    http.get(Uri.parse(baseurl)).then( (response) {
      var jsondata = json.decode(response.body);
      var questions = jsondata['results'];  // get the questions array

  setState(() {
	 _question = questions[0]['question'];
   _Canswer = questions[0]['correct_answer'];
   _Ranswer = questions[0]['incorrect_answers'][0];
   _Ranswer1 = questions[0]['incorrect_answers'][1];
   _Ranswer2 = questions[0]['incorrect_answers'][2];
      });
      // debug
      i++;
    });
  }

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      
      //when the quiz ends
      if (_questionIndex + 1 == 10) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= 10) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
      _doGet();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(k==0){
          _doGet();
k++;
    }
    
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4418E), Color(0xFF0652C5)],),
        ),

        child: Column(
          children: [
           
            Container(
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0, top: 70.0),
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          SizedBox(height: 20.0,),
      
                ElevatedButton( 
              
              onPressed: () { _questionAnswered(true); },
            child: Text(_Canswer)),
            
                      SizedBox(height: 20.0,),

          
          
            ElevatedButton( 
              
              onPressed: () {  _questionAnswered(false);},
              child: Text(_Ranswer)),
                    SizedBox(height: 20.0,),

            ElevatedButton( 
              
              onPressed: () {  _questionAnswered(false);},
              child: Text(_Ranswer1)),
                        SizedBox(height: 20.0,),

            ElevatedButton( 
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10.0)
              ),
              onPressed: () {  _questionAnswered(false);},
              child: Text(_Ranswer2)
              ),
            
            
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
                padding: EdgeInsets.only(bottom: 40.0, top: 40.0),
              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please select an answer before going to the next question'),
                  ));
                  return;
                }
                _nextQuestion();
                _doGet();
              },
              child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question'),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${10}',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected
                        ? 'Well done, you got it right!'
                        : 'Wrong :/',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    _totalScore > 4
                        ? 'Congratulations! Your final score is: $_totalScore'
                        : 'Your final score is: $_totalScore. Better luck next time!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

