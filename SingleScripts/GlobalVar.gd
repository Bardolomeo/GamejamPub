extends Node

var chKey = "" #da rivedere
var choiceNum = 0
var choiceCap = 10
var gold = 0
var day = 0
var stage = 1
var prevChoice = 0

#Info party
var firstmember = "Ch1"
var firstmemberlife : int = 0
var firstmemberfirstmovePP : int = 0
var firstmembersecondmovePP : int = 0
var firstmemberthirdmovePP : int = 0
var secondmember = "none"
var secondmemberlife : int = 0
var secondmemberfirstmovePP : int = 0
var secondmembersecondmovePP : int = 0
var secondmemberthirdmovePP : int = 0
var thirdmember = "none"
var thirdmemberlife : int = 0
var thirdmemberfirstmovePP : int = 0
var thirdmembersecondmovePP : int = 0
var thirdmemberthirdmovePP : int = 0

#Trinkets
var ancientRune = "none"
var enchFeather = "none"
var monocle = "none"
var oldTome = "none"
var oldtomeflag = 0
var pocketDagger = "none"
var regenStone = "none"

#Start battle status
var partypoison = false
var partyweak = false
var partyslow = false
var partyregen = false
var partyhaste = false
var partystrength = false
var enemystun = false
var enemyweak = false

func _ready():
	pass
