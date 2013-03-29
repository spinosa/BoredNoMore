BoredNoMore
===========

It's a silly iOS example app making use of my bored gesture recognizer, DSBoredGestureRecognizer.

The real code is in `BoredNoMore/DSBoredGestureRecognizer.<m|h>`

DSBoredGestureRecognizer
===========
The gesture recognizer Apple forgot.  Maybe they don't get bored, but maybe your users do.  Finally, you can detect boredom and fix it by showing pictures culled from 4chan (or whatever floats your boat).

The `DSBoredGestureRecognizer` looks for the classic waterfall from pinky to index finger.  By default, it waits for two of these sequences before signaling recognized.  You can customize the number of required sequences with `-[DSBoredGestureRecognizer setNumberOfSequencesRequired:(NSUInteger)]`

Want to detect that a user is more impatient than bored?  You can also reduce the grace period allotted between waterfall sequences via `-[DSBoredGestureRecognizer setGraceBetweenSequences:(NSTimeInterval)]`

Accessiblity is important.  If your users have more or fewer fingers, adjust the minimum number of fingers required in the waterfall with `-[DSBoredGestureRecognizer setNumberOfTouchesRequired:(NSUInteger)]`

PS You should attach this gesture to a full window root view.  Want to know why?  Read the code and comments.
