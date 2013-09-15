package {
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class TriviaGame extends MovieClip {
		
		//XML parsing
		private var dataXML:XML;
		
		//Formatting of text
		private var questionFormat:TextFormat;
		private var answerFormat:TextFormat;
		private var scoreFormat:TextFormat;
		
		//Text fields
		private var messageField:TextField;
		private var questionField:TextField;
		private var scoreField:TextField;
		
		//sprites
		private var gameSprite:Sprite;
		private var questionSprite:Sprite;
		private var answerSprites:Sprite;
		private var gameButton:GameButton;
		
		//Data, Control and scoring
		private var questionNum:int;
		private var correctAnswer:String;
		private var numQuestionsAsked:int;
		private var numCorrect:int;
		
		//Used to store items from the XML answers node
		private var answers:Array;
		
		public function startTriviaGame() {
			//Create a sprite object for the game
			gameSprite = new Sprite();
			addChild(gameSprite);
			
			//Define the TextFormat object
			questionFormat = new TextFormat("Arial", 24, 0x330000, true, false, false, null, null, "center");
			answerFormat = new TextFormat("Arial", 18, 0x330000, true, false, false, null, null, "left");
			scoreFormat = new TextFormat("Arial", 18, 0x330000, true, false, false, null, null, "center");
			
			//Define the TextField objects for game messages
			scoreField = createText("", questionFormat, gameSprite, 0, 370, 550);
			messageField = createText("Loading Questions...", questionFormat, gameSprite, 0, 50, 550);
			
			//Initialize the control attributes of the game
			questionNum = 0;
			numQuestionsAsked = 0;
			numCorrect = 0;
			
			//Call the showScore() function
			showScore();
			
			//Import XML file data
			xmlImport();
		}
		
		//start loading of questions
		public function xmlImport() {
			var xmlURL:URLRequest = new URLRequest("trivia.xml");
			var xmlLoader:URLLoader = new URLLoader(xmlURL);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			trace("XML data loaded.");
		}
		
		//questions loaded
		public function xmlLoaded(event:Event) {
			dataXML = XML(event.target.data);
			gameSprite.removeChild(messageField);
			messageField = createText("Get ready for the first question!", questionFormat, gameSprite, 0, 60, 550);
			showGameButton("GO!");
			
			trace("Number of questions:" + dataXML.child("*").length());
			trace("First question:" + dataXML.child(0).child(0));
			trace("Answer:" + dataXML.child(0).child(1).child(0));
		}
		
		//creates a text field and returns it
		public function createText(text:String, tf:TextFormat, spr:Sprite, x,y:Number, width:Number): TextField {
			var tField:TextField = new TextField();
			tField.x = x;
			tField.y = y;
			tField.width = width;
			tField.defaultTextFormat = tf;
			tField.selectable = false;
			tField.multiline = true;
			tField.wordWrap = true;
			
			if(tf.align == "left") {
				tField.autoSize = TextFieldAutoSize.LEFT;
			} else if (tf.align == "right") {
				tField.autoSize = TextFieldAutoSize.RIGHT;
			} else {
				tField.autoSize = TextFieldAutoSize.CENTER;
			}
			
			tField.text = text;
			spr.addChild(tField);
			return tField;
		}
		
		//updates the score
		public function showScore() {
			scoreField.text = "Number of Questions: " + numQuestionsAsked + " Number Correct: " + numCorrect;
		}
		
		//ask player if they are ready for next question
		public function showGameButton(buttonLabel:String) {
			gameButton = new GameButton();
			trace("buttonLabel:" + buttonLabel);
			gameButton.label.text = buttonLabel;
			trace("Wording of gameButton.label.text:" + gameButton.label.text);
			gameButton.x = 220;
			gameButton.y = 342;
			gameSprite.addChild(gameButton);
			
			gameButton.addEventListener(MouseEvent.CLICK, pressedGameButton);
		}
		
		//player is ready
		public function pressedGameButton(event:MouseEvent) {
			trace("Clicked gameButton");
			
			//Remove a question, if one if already showing
			if(questionSprite != null) {
				gameSprite.removeChild(questionSprite);
			}
			
			//remove button and message
			gameSprite.removeChild(gameButton);
			gameSprite.removeChild(messageField);
			
			trace("Questions remaining:" + dataXML.child("*").length());
			
			//ask the next question
			if(questionNum >= dataXML.child("*").length()) {
				gotoAndStop("gameover");
			} else {
				askQuestion();
			}
		}
		
		//set up the question
		public function askQuestion() {
			trace("askQuestion");
			
			//prepare new qustion sprite
			questionSprite = new Sprite();
			gameSprite.addChild(questionSprite);
			
			//Access the question to ask
			//questionNum
			var question:String = dataXML.item[questionNum].question;
			trace("Question displayed:" + dataXML.child(0).child(questionNum));
			
			//Add test code here
			
			
			//display the question
			questionField = createText(question, questionFormat, questionSprite, 0, 60, 550);
			
			//...More to follow
			testXMLData(dataXML);
			correctAnswer = dataXML.item[questionNum].answers.answer[0];
			trace("Test correct answer:" + correctAnswer);
			
			//Substitue for testing
			//testXMLData(dataXML);
			//answers = testShuffle(dataXML.item[questionNum].answers);
			answers = shuffleAnswers(dataXML.item[questionNum].answers);
			
			answerSprites = new Sprite();
			for(var ans:int = 0; ans < answers.length; ans++) {
				//create an answer
				var answer:String = answers[ans];
				var answerSprite:Sprite = new Sprite();
				var letter:String = String.fromCharCode(65+ans);
				var answerField:TextField = createText(answer, answerFormat, answerSprite, 0, 0, 450);
				
				//place a Circle object to the left of each answer
				var circle:Circle = new Circle(); //from library
					circle.letter.text = letter;
					answerSprite.x = 100;
					answerSprite.y = 150 + ans * 50;
					answerSprite.addChild(circle);
					
				//make it a button
				answerSprite.addEventListener(MouseEvent.CLICK, clickAnswer);
				answerSprite.buttonMode = true;
				answerSprites.addChild(answerSprite);
			}
			questionSprite.addChild(answerSprites);
			//The closing brace of the function follows
			
			trace("Question displayed:" + dataXML.child(0).child(questionNum));
			trace("Question displayed:" + dataXML.child(1).child(0));
			for(var qnum:uint = 0; qnum < dataXML.child("*").length(); qnum++) {
				trace("Question #" + qnum + ":" + dataXML.child(qnum).child(0));
			}
		}
		
		function testXMLData(xmlData:XML): void {
			var questnum:uint = 0;
			trace("The answers for question: " + questnum);
			trace("Found: " + xmlData.child(0).child("*").length());
			for (var anum:uint = 0; anum < xmlData.child(0).child("*").length(); anum++) {
				//With child
				trace("Question displayed: (" + String.fromCharCode(65 + anum) + ")" + xmlData.child(questnum).child(1).child(anum));
				//Without child
				trace(xmlData.item.answers.answer[anum]);
			} //end for
		}
		
		function testShuffle(xlmElement:XMLList): Array{
			trace("Test element shuffle");
			var testAnswers:Array = new Array();
			var anum:uint = 0;
			while(anum < xlmElement.child("*").length()) {
				testAnswers[anum] = xlmElement.child(anum);
				trace("Answer:" + testAnswers[anum]);
				anum++;
			} //end while
			return testAnswers;
		}
		
		//take the answers and shuffle them into an array
		public function shuffleAnswers(answers:XMLList) {
			var shuffledAnswers:Array = new Array();
			while (answers.child("*").length() > 0) {
				var rnum:int = Math.floor(Math.random() * answers.child("*").length());
					shuffledAnswers.push(answers.answer[rnum]);
					delete answers.answer[rnum];
			}
			return shuffledAnswers;
		}
		
		//select an answer
		public function clickAnswer(event:MouseEvent) {
			//get selected answer text, and compare
			var selectedAnswer = event.currentTarget.getChildAt(0).text;
			if (selectedAnswer == correctAnswer) {
				numCorrect++;
				messageField = createText("You got it!", questionFormat, gameSprite, 0, 120, 550);
			} else {
				messageField = createText("Incorrect! The Correct answer was:", questionFormat, gameSprite, 0, 120, 550);
			}
			finishQuestion();
			trace("clickAnswer:" + selectedAnswer);
		}
		
		//process the answer
		public function finishQuestion() {
			//remove all but the correct answer
			for (var ans:int = 0; ans < 4; ans++) {
				answerSprites.getChildAt(ans).removeEventListener(MouseEvent.CLICK, clickAnswer);
				if (answers[ans] != correctAnswer) {
					answerSprites.getChildAt(ans).visible = false;
				} else {
					answerSprites.getChildAt(ans).y = 200;
				}
			}
			//next question
			questionNum++;
			numQuestionsAsked++;
			showScore();
			showGameButton("Continue");
		}
		
		//clean up sprites
		public function cleanup() {
			removeChild(gameSprite);
			gameSprite = null;
			questionSprite = null;
			answerSprites = null;
			dataXML = null;
		}
	} //end class
} //end package