package {
	import flash.display.*;
	import flash.events.*;
	
	public class MatchingGame extends MovieClip {

		private const boardWidth:uint = 6;
		private const boardHeight:uint = 6;
		private const cardHorizontalSpacing:Number = 52;
		private const cardVerticalSpacing:Number = 52;
		private const boardOffsetX:Number = 120;
		private const boardOffsetY:Number = 45;
		
		private var firstCard:Card;
		private var secondCard:Card;
		private var cardsLeft:uint;
		
		
		public function MatchingGame():void {
			//implementation needed

		//make a list of card numbers
		var cardlist:Array = new Array();
		//make a list of card numbers
		for(var cnum:uint=0; cnum < boardWidth* boardHeight / 2; cnum++) {
			cardlist.push(cnum);
			trace(cnum);
			cardlist.push(cnum);
			trace(cnum);
		}
			cardsLeft = 0;
			trace("init value:" + cardsLeft);
			
			for(var x:uint=0; x < boardWidth; x++) {
				for(var y:uint=0; y < boardHeight; y++) {
					var mcard:Card = new Card();
					mcard.stop();
					mcard.x = x * cardHorizontalSpacing + boardOffsetX;
					mcard.y = y * cardVerticalSpacing + boardOffsetY;
					cardsLeft++;
					trace("adding:" + cardsLeft);
					//Get a random face
					var rface:uint = Math.floor(Math.random() * cardlist.length);
					//Dynamic creation of a property
					mcard.cardFace = cardlist[rface]; //assign face to card
					cardlist.splice(rface,1); //remove face from list
					//have this card listen for clicks
					mcard.addEventListener(MouseEvent.CLICK, clickCard);
					//test to see the images on the cards
					/* mcard.gotoAndStop(mcard.cardFace + 2); */
					addChild(mcard);
				}
			}//end for implementation
			
	    }//end of constructor
		//player clicked on a card
		public function clickCard(event:MouseEvent) {
			var thisCard:Card = (event.currentTarget as Card); //what card?
			trace(thisCard.cardFace);
			
		if (firstCard == null) { //first card in a pair
			firstCard = thisCard; //noted
			firstCard.gotoAndStop(thisCard.cardFace + 2); //turn it over
		} else if (firstCard == thisCard) { //clicked first card again
			firstCard.gotoAndStop(1); //turn back over
			firstCard = null;
		} else if (secondCard == null) { //second card in a pair
			secondCard = thisCard; //note it
			secondCard.gotoAndStop(thisCard.cardFace + 2); //turn it over
			
			//compare two cards
			if (firstCard.cardFace == secondCard.cardFace) {
				//remove a match
				removeChild(firstCard);
				removeChild(secondCard);
				//reset selection
				firstCard = null;
				secondCard = null;
				//check for gameover
				cardsLeft -= 2; //2 less cards
				
				trace("decremented:" + cardsLeft);
				if(cardsLeft == 0) {
					trace("Game Over");
					gotoAndStop("gameover");
				} //if cardsLeft
			} //end if firstCard
		} else { //starting to pick another pair
			//reset previous pair
			firstCard.gotoAndStop(1);
			secondCard.gotoAndStop(1);
			secondCard = null;
			//select first card in next pair
			firstCard = thisCard;
			firstCard.gotoAndStop(thisCard.cardFace + 2);
		}
		
		} //end click card
		
    }// end of class
	
}
// step 4 of iLab 5