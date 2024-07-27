extends enemyprojectile

func setvalues():
	decay=1
	stun=0.2
	damage=2
func process(delta):
	look_at(globalveloc())
