# Gaddag

Adapted from: https://nullwords.wordpress.com/2013/02/27/gaddag-data-structure/

A GADDAG is a data structure presented by Steven Gordon in 1994, for use in generating moves for Scrabble and other word-generation games where such moves require words that "hook into" existing words. A GADDAG is a specialization of a Trie, containing states and branches to other GADDAGs. (Source: http://en.wikipedia.org/wiki/GADDAG)

	var gaddag = Gaddag()
	gaddag.add("cat")
	gaddag.add("cater")
	gaddag.add("caterpillar")
	gaddag.add("catered")
	// Check to see if a word is defined
	if gaddag.wordDefined("caterpillar") {
	  // Do something
	}
	// Check to see which words we can make with the tiles in our rack
	for word in gaddag.findWords("", rack: "catered") {
	  // Do something
	}
