# Gaddag

Ported from: https://nullwords.wordpress.com/2013/02/27/gaddag-data-structure/

A GADDAG is a data structure presented by Steven Gordon in 1994, for use in generating moves for Scrabble and other word-generation games where such moves require words that "hook into" existing words. A GADDAG is a specialization of a Trie, containing states and branches to other GADDAGs. (Source: http://en.wikipedia.org/wiki/GADDAG).

There are some limitations to this project, the first one being that it takes a long time to load the data into the data structure (several minutes for a file roughly the size of SOWPODS), the second one being that this initial load has to occur each time Gaddag() is called, thirdly the sheer amount of memory it uses is unacceptable for such a data structure. I am looking at minifying this data structure and sharing similar nodes/paths.

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
