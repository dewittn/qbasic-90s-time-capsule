DECLARE SUB BubbleSort (array%(), number%)
DECLARE SUB Shuffle (shuffledArray%())
DECLARE SUB DisplayCard (verticalPos%, horizontalPos%, card%, show%)
DECLARE SUB CountHand (hand%(), number%, total%)
DECLARE SUB Winner ()
DECLARE SUB DealerPlay ()
DECLARE SUB Pause ()
DECLARE SUB PlayerPlay (over21%)
DECLARE SUB MovePointer ()
DECLARE SUB GetBet (quit%)
DECLARE SUB StartGame (win%)
DECLARE SUB InitializeDeck ()

'   Filename: BJACK.BAS
'
'   Author: Douglas Hergert
'
'   For: Qbasic 1.x, QuickBASIC 2.x - 4.5
'
'   Plays the game of 21 (or Blackjack). The computer is always
'       the dealer, and the person at the keyboard is the player.
'       No "splitting" of pairs is allowed, nor is "doubling down" of
'       bets allowed. The player begins with $250, and may place bets
'       that range from $10 to $100.

'---------------------| Global Variable Declarations |---------------------

        OPTION BASE 1
        DIM rank$(13), deck%(52), playerHand%(11), dealerHand%(11)

        COMMON SHARED rank$(), deck%(), playerHand%(), dealerHand%(), nextCard%, currentHoldings%, betAmount%, playerCards%, dealerCards%, true%, false%

'   ---- Set the player's initial gambling sum to $250.
    currentHoldings% = 250

'   ---- Initialize Boolean variables true% and false%.
    true% = -1
    false% = 0

'----------------------------| Function Area |-----------------------------

'   The Upper$ function converts alphabetic characters in a string
'       value into uppercase letters.

DEF FNUpper$ (textVal$)
    STATIC i%, number%, character$

'   ---- Find the length of the string value received.
    number% = LEN(textVal$)

'   ---- Examine each character in the string, and convert as necessary.
    FOR i% = 1 TO number%
        character$ = MID$(textVal$, i%, 1)
        IF (character$ >= "a" AND character$ <= "z") THEN
            MID$(textVal$, i%) = CHR$(ASC(character$) - 32)
        END IF
    NEXT i%
    FNUpper$ = textVal$
END DEF

'   The TransCard$ function translates a number from 1 to 52 into a
'       two-character string representing the suit and rank of the
'       corresponding card.

DEF FNTransCard$ (cardNumber%)
    suit$ = CHR$(((cardNumber% - 1) \ 13) + 3)
    rnk$ = rank$(((cardNumber% - 1) MOD 13) + 1)
    FNTransCard$ = suit$ + rnk$
END DEF

'   The HitOrStay function asks the player if he or she wants to "hit"
'       (take another card), or "stay" (play with the current hand).
'       HitOrStay returns a value of true if the player wants to stay.

DEF FNHitOrStay
    LOCATE playerCards% + 12, 5
    answer$ = ""
    PRINT "Your hand: Hit or Stay? ";
    WHILE (answer$ = "") OR (INSTR("HS", answer$) = 0)
        LOCATE , , 1
        answer$ = INKEY$
        answer$ = FNUpper$(answer$)
    WEND
    LOCATE playerCards% + 12, 5: PRINT SPACE$(25);
    FNHitOrStay = (answer$ = "S")
END DEF

'-------------------------| Main Program Area |----------------------------
   
    CLS
    LOCATE , , 1

'   ---- Initialize the deck, and shuffle it.
    CALL InitializeDeck
    nextCard% = 1
    CALL Shuffle(deck%())

'   ---- The play:  For each round, get a bet, deal two cards each to the
'        player and the dealer, and draw more cards if appropriate.
'        Declare the result of the round.

    gameOver% = false%
    WHILE NOT gameOver%
        CALL GetBet(gameOver%)

        IF NOT gameOver% THEN
            CALL StartGame(roundOver%)
            IF NOT roundOver% THEN
                CALL PlayerPlay(busted%)
                IF NOT busted% THEN
                    CALL DealerPlay
                END IF
            END IF
            CALL Winner
        END IF
    WEND

    END

'----------------------------| Subprogram Area |---------------------------

DATA 2,3,4,5,6,7,8,9,T,J,Q,K,A

'   The BubbleSort subprogram is a bubble sort routine.  It is used to
'       rearrange the cards in a hand before the hand is diplayed on the
'       screen.  Since a hand seldom has more than five or six cards, a
'       bubble sort is just as efficient as any of the more sophisticated
'       sorting routines.
SUB BubbleSort (array%(), number%) STATIC
    FOR i% = 1 TO (number% - 1)
        FOR j% = 1 TO (number% - 1)
            IF (array%(i%) > array%(j%)) THEN SWAP array%(i%), array%(j%)
        NEXT j%
    NEXT i%
END SUB

'   The CountHand subprogram counts the value of a hand, and returns the
'       value of the count in the total% parameter.  The other parameters
'       are hand%, an array of card numbers, and number%, the number
'       of cards in the hand.
SUB CountHand (hand%(), number%, total%) STATIC
    total% = 0
    aces% = 0

'   ---- Tens, Jacks, Queens, and Kings are worth ten. The ace is worth
'        eleven unless the player's hand is over 21.  Other cards are
'        worth their face value.
    FOR i% = 1 TO number%
        cardRank$ = RIGHT$(FNTransCard$(hand%(i%)), 1)
        IF (INSTR("TJQK", cardRank$) <> 0) THEN
            cardValue% = 10
        ELSEIF (cardRank$ = "A") THEN
            cardValue% = 11
            aces% = aces% + 1
        ELSE
            cardValue% = VAL(cardRank$)
        END IF
        total% = total% + cardValue%
    NEXT i%

'   ---- If total% is over 21, and if the hand contains aces, count one
'        or more aces as 1 rather than 11.
    WHILE (total% > 21) AND (aces% > 0)
        total% = total% - 10
        aces% = aces% - 1
    WEND
END SUB

'   The DealerPlay subprogram draws more cards for the dealer's hand until
'       the count is 17 or over.
SUB DealerPlay STATIC
'   ---- Begin by displaying the dealer's hidden card.
    CALL DisplayCard(2, 35, dealerHand%(1), true%)

'   ---- Count the hand.
    CALL CountHand(dealerHand%(), dealerCards%, dealerTotal%)

'   ---- The dealer must stay at 17 or greater, no matter what the player's
'        count is.
    WHILE dealerTotal% < 17

'   ---- Deal the dealer another card.
        LOCATE 11 + dealerCards%, 37: PRINT SPACE$(30)
        LOCATE 12 + dealerCards%, 37
        PRINT "Count is"; dealerTotal%; "==> Dealer hits."
        CALL Pause
        dealerCards% = dealerCards% + 1
        dealerHand%(dealerCards%) = deck%(nextCard%)
        CALL BubbleSort(dealerHand%(), dealerCards%)

'   ---- Display the dealer's cards, sorted by suit.
        FOR i% = 1 TO dealerCards%
            verticalPos% = i% + 1
            horizontalPos% = 32 + i% * 3
            CALL DisplayCard(verticalPos%, horizontalPos%, dealerHand%(i%), true%)
        NEXT i%
        CALL MovePointer
        CALL CountHand(dealerHand%(), dealerCards%, dealerTotal%)
    WEND

'   ---- Display the appropriate card count information.
    LOCATE 11 + dealerCards%, 37: PRINT SPACE$(30)
    LOCATE 12 + dealerCards%, 37
    IF (dealerTotal% > 21) THEN
        PRINT "Count is"; dealerTotal%; "==> Busted!" + SPACE$(8)
    ELSE
        PRINT "Count is"; dealerTotal%; "==> Dealer stays."
    END IF
END SUB

'   The DisplayCard subprogram displays one card on the screen.  The
'       subprogram has four parameters:  verticalPos% and horizontalPos%
'       are the line and column locations of the upper-left corner of the
'       card display; card% is the card's number (from 1 to 52); and show%
'       is a Boolean value indicating whether the card is to be displayed
'       face up or face down.
SUB DisplayCard (verticalPos%, horizontalPos%, card%, show%) STATIC
'   ---- Begin by drawing the outline of the card.
    topEdge$ = CHR$(218) + STRING$(14, 196) + CHR$(191)
    LOCATE verticalPos%, horizontalPos%: PRINT topEdge$

    FOR i% = verticalPos% + 1 TO verticalPos% + 8
        LOCATE i%, horizontalPos%: PRINT CHR$(179)
    NEXT i%

    LOCATE verticalPos% + 9, horizontalPos%: PRINT CHR$(192) + STRING$(2, 196)

'   ---- If the card is face up (show% is true), display the card's suit and
'        value.  Use the TransCard$ function to determine these from the
'        card's number.
    IF show% THEN

'   ---- Prepare a two-character string containing symbols for the card's
'        suit and vlaue.
    card$ = FNTransCard$(card%)

'   ---- Print the suit.
        LOCATE verticalPos% + 2, horizontalPos% + 1: PRINT LEFT$(card$, 1)

'   ---- If the card value in the card$ string is "T", print "10";
'        otherwise print the value followed by a space.
        LOCATE verticalPos% + 1, horizontalPos% + 1
        IF RIGHT$(card$, 1) = "T" THEN
            PRINT "10"
        ELSE
            PRINT RIGHT$(card$, 1) + " "
        END IF

    END IF
END SUB

'   The GetBet subprogram announces the player's current holdings (or
'       indebtedness), and invites the player to place a bet.
SUB GetBet (quit%) STATIC
    lowBet% = 10
    highBet% = 100
    PRINT : PRINT : PRINT
    PRINT "     Twenty-one"
    PRINT "     =========="
    PRINT
    PRINT "        The computer is the dealer."
    PRINT "        ";
    IF (currentHoldings% >= 0) THEN
        PRINT USING "You currently have: $$#,###"; currentHoldings%
    ELSE
        PRINT USING "You owe the house: $$#,###"; ABS(currentHoldings%)
        PRINT "        (The house extends credit.)"
    END IF

        PRINT
        PRINT "     Place your bet."
        PRINT "     ---------------"
        PRINT "        The house betting limits are:"
        PRINT USING "           ->  minimum bet -- $$###"; lowBet%
        PRINT USING "           ->  maximum bet -- $$###"; highBet%
        PRINT "        (Press <Enter> for maximum bet.)"
        PRINT "        (Press <Q> to Quit.)"
        PRINT

'   ---- Read the bet amount as a string value, betString$.  If betString$
'        is empty, assume that the player wants to bet the maximum amount.
'        If betString$ is "Q", Quit the program.
        ok% = false%
        WHILE NOT ok%
            PRINT "              ";
            INPUT "==> ", betString$
            IF betString$ = "" THEN
                betAmount% = highBet%
                ok% = true%
                quit% = false%
            ELSEIF (betString$ = "Q") OR (betString$ = "q") THEN
                ok% = true%
                quit% = true%
            ELSE
                betAmount% = VAL(betString$)
                ok% = (betAmount% >= lowBet%) AND (betAmount% <= highBet%)
                quit% = false%
            END IF
        WEND
        CLS
END SUB

'   The InitializeDeck subprogram initializes the rank$ and deck% arrays.
SUB InitializeDeck STATIC
    FOR i% = 1 TO 13
        READ rank$(i%)
    NEXT i%

    FOR i% = 1 TO 52
        deck%(i%) = i%
    NEXT i%
END SUB

'   The MovePointer subprogram increments the nextCard% variable.  When
'       nextCard% goes past 52, this routine shuffles all the cards that
'       aren't currently on the table.
SUB MovePointer STATIC
    nextCard% = nextCard% + 1

    IF (nextCard% > 52) THEN
        tableCards% = playerCards% + dealerCards%
        usedCards% = 52 - tableCards%
        LOCATE 25, 25: PRINT "Reshuffling"; usedCards%; "cards...";

'   ---- The tempDeck% array will contain all those cards that are not
'        in a current hand.
        REDIM tempDeck%(usedCards%)

        FOR i% = 1 TO usedCards%
            tempDeck%(i%) = deck%(i%)
        NEXT i%

'   ---- Shuffle the tempDeck% array.
        CALL Shuffle(tempDeck%())

'   ---- For the next shuffle, keep a record of the cards that are on the
'        table.  (In effect, put these cards on the bottom of the deck.)
        FOR i% = 1 TO usedCards%
            deck%(tableCards% + i%) = tempDeck%(i%)
        NEXT i%

'   ---- The nextCard% variable should point to the top of the newly
'        shuffled cards.
        nextCard% = tableCards% + 1
        CALL Pause
        LOCATE 25, 25: PRINT SPACE$(54);
    END IF
END SUB

'   The Pause subprogram suspends the program until the player is ready to
'       continue. Pause places a message in the lower-right corner of the
'       screen, and waits for the player to press the Enter key (any key
'       will work).
SUB Pause STATIC
    LOCATE 25, 50: PRINT "Press <Enter> to continue.";
    character$ = ""
    WHILE character$ = ""
        character$ = INKEY$
    WEND
END SUB

'   The PlayerPlay subprogram gives the player a chance to take more cards.
'       If the player's hand goes over 21, PlayerPlay returns a value of
'       true in the variable over21%.
SUB PlayerPlay (over21%) STATIC
    over21% = false%
    done% = false%

'   ---- Continue until the player is done or the hand goes over 21.
    WHILE NOT (over21% OR done%)
        done% = FNHitOrStay
        IF NOT done% THEN

'   ---- Deal the player another card.
            playerCards% = playerCards% + 1
            playerHand%(playerCards%) = deck%(nextCard%)

'   ---- Redisplay the hand with the new card (sort cards by suit).
            CALL BubbleSort(playerHand%(), playerCards%)
            FOR i% = 1 TO playerCards%
                CALL DisplayCard(i% + 1, i% * 3, playerHand%(i%), true%)
            NEXT i%
            CALL MovePointer

'   ---- Analyze the new hand count.
            CALL CountHand(playerHand%(), playerCards%, playerTotal%)
            IF (playerTotal% > 21) THEN
                over21% = true%
                LOCATE playerCards% + 12, 5
                PRINT "Count is"; playerTotal%; "==> Busted!"
                BEEP
            ELSEIF (playerTotal% = 21) THEN
                done% = true%
            END IF
        ELSE
            CALL CountHand(playerHand%(), playerCards%, playerTotal%)
        END IF
    WEND

    IF done% THEN
        LOCATE playerCards% + 12, 5
        PRINT "Count is"; playerTotal%
    END IF
END SUB

SUB Shuffle (shuffledArray%()) STATIC
'   ---- Use the current time as the seed for RANDOMIZE, QuickBASIC's
'        built-in random-number generator.
    RANDOMIZE (TIMER)

'   ---- Find the length of the array to be shuffled.
    length% = UBOUND(shuffledArray%)

'   ---- Swap each element of the array with a randomly selected element.
    FOR card% = 1 TO length%
        randomCard% = INT(RND * length%) + 1
        SWAP shuffledArray%(card%), shuffledArray%(randomCard%)
    NEXT card%
END SUB

'   The StartGame subprogram deals the first two cards to the player and
'       the dealer, and determines if anyone has 21 at the outset.  If so,
'       StartGame sends a Boolean value of true back to the main program
'       in the win% variable.
SUB StartGame (win%) STATIC
    playerCards% = 0: dealerCards% = 0
    FOR i% = 1 TO 2
        playerHand%(i%) = deck%(nextCard%)
        CALL DisplayCard(i% + 1, i% * 3, playerHand%(i%), true%)
        playerCards% = playerCards% + 1
        CALL MovePointer

        dealerHand%(i%) = deck%(nextCard%)
        CALL DisplayCard(i% + 1, 32 + i% * 3, dealerHand%(i%), 1 - i%)
        dealerCards% = dealerCards% + 1
        CALL MovePointer
    NEXT i%

    LOCATE 14, 5: PRINT "Your hand"
    LOCATE 14, 37: PRINT "The dealer's hand"

'   ---- Count the hands.
    CALL CountHand(playerHand%(), 2, playerTotal%)
    CALL CountHand(dealerHand%(), 2, dealerTotal%)

'   ---- Analyze the situation, and display the value of each hand if
'        appropriate.  (The dealer's hand will not be displayed if the
'        player gets a 21.)
    IF (dealerTotal% = 21) OR (playerTotal% = 21) THEN
        win% = true%

        IF (dealerTotal% = 21) THEN
            CALL DisplayCard(2, 35, dealerHand%(1), true%)
            LOCATE 15, 40
            PRINT "Twenty-one!"
        END IF

        LOCATE 15, 4
        IF (playerTotal% = 21) THEN
            PRINT "Twenty-one!"
        ELSE
            PRINT "Count is: "; playerTotal%
        END IF
    ELSE
        win% = false%
    END IF
END SUB

'   The Winner subprogram announces whether the player has won or lost,
'       and adds the bet amount to---or subtracts it from---the player's
'       current holdings.
SUB Winner STATIC
    CALL CountHand(playerHand%(), playerCards%, playerTotal%)
    CALL CountHand(dealerHand%(), dealerCards%, dealerTotal%)

'   ---- If the counts of the two hands are equal, the round is a draw.
    IF (playerTotal% = dealerTotal%) THEN
        difference% = 0

'   ---- If the player has busted, or has a lower count than the dealer,
'        the player loses.
    ELSEIF (playerTotal% > 21) OR (playerTotal% < dealerTotal% AND dealerTotal% < 22) THEN
        difference% = -1 * betAmount%
    ELSE

'   ---- If the player had 21 after the intial deal (of 2 cards)
'        then the player earns twice the bet.
        IF (playerTotal% = 21) AND (playerCards% = 2) THEN
            difference% = 2 * betAmount%

'   ---- Otherwise, the player simply earns the bet itself.
        ELSE
            difference% = betAmount%
        END IF
    END IF

'   ---- Add difference% (a negative or positive amount) to the player's
'        current worth, currentHoldings%.
    currentHoldings% = currentHoldings% + difference%

'   ---- Announce the result of the round.
    LOCATE 25, 10
    IF (difference% = 0) THEN
        PRINT "A draw... ";
    ELSEIF (difference% < 0) THEN
        PRINT USING "You lose $$###."; -1 * difference%;
    ELSE
        PRINT USING "You win $$###."; difference%;
    END IF

    CALL Pause
    CLS
END SUB

