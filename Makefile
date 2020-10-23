_default_target:
	grep --only-matching --extended-regexp '^[-_a-zA-Z0-9]+:' Makefile

amend:
	git commit -a --amend --no-edit 
	git push --force

export:
	cd ../p; tar cvzf - .images .gitignore | (cd ../o; tar xvzf - )
	cd ../p; tar cvzf - * | (cd ../o; tar xvzf - )

import:
	make -C ../p export
