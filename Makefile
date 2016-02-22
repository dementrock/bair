all: index students alumni publications courses getting_involved

index: templates/index.rbhtml templates/_layout.rbhtml
	./render_template index.rbhtml > index.html

students: templates/students.rbhtml templates/_layout.rbhtml
	./render_template students.rbhtml > students.html

alumni: templates/alumni.rbhtml templates/_layout.rbhtml
	./render_template alumni.rbhtml > alumni.html

publications: templates/publications.rbhtml templates/_layout.rbhtml
	./render_template publications.rbhtml > publications.html

courses: templates/courses.rbhtml templates/_layout.rbhtml
	./render_template courses.rbhtml > courses.html

getting_involved: templates/getting_involved.rbhtml templates/_layout.rbhtml
	./render_template getting_involved.rbhtml > getting_involved.html
