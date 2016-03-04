all: index students alumni publications courses getting_involved sponsor faculty software seminar

index: templates/index.rbhtml templates/_layout.rbhtml
	./render_template index.rbhtml > index.html

students: templates/students.rbhtml templates/_layout.rbhtml
	./render_template students.rbhtml > students.html
	./render_template students.rbhtml postdoc > students_postdoc.html
	./render_template students.rbhtml phd > students_phd.html
	./render_template students.rbhtml master > students_master.html
	./render_template students.rbhtml undergraduate > students_undergraduate.html

alumni: templates/alumni.rbhtml templates/_layout.rbhtml
	./render_template alumni.rbhtml > alumni.html
	./render_template alumni.rbhtml postdoc > alumni_postdoc.html
	./render_template alumni.rbhtml phd > alumni_phd.html
	./render_template alumni.rbhtml master > alumni_master.html
	./render_template alumni.rbhtml undergraduate > alumni_undergraduate.html
	./render_template alumni.rbhtml research_scientist > alumni_research_scientist.html


publications: templates/publications.rbhtml templates/_layout.rbhtml
	./render_template publications.rbhtml > publications.html

courses: templates/courses.rbhtml templates/_layout.rbhtml
	./render_template courses.rbhtml > courses.html

getting_involved: templates/getting_involved.rbhtml templates/_layout.rbhtml
	./render_template getting_involved.rbhtml > getting_involved.html

sponsor: templates/sponsor.rbhtml templates/_layout.rbhtml
	./render_template sponsor.rbhtml > sponsor.html

faculty: templates/faculty.rbhtml templates/_layout.rbhtml
	./render_template faculty.rbhtml > faculty.html

software: templates/software.rbhtml templates/_layout.rbhtml
	./render_template software.rbhtml > software.html

seminar: templates/seminar.rbhtml templates/_layout.rbhtml
	./render_template seminar.rbhtml > seminar.html


fonts:

