all: index faculty students alumni publications courses getting_involved sponsor software seminar

DEPLOY_FOLDER=deploy

index: templates/index.rbhtml templates/_layout.rbhtml
	./render_template index.rbhtml > $(DEPLOY_FOLDER)/index.html

students: templates/students.rbhtml templates/_layout.rbhtml
	./render_template students.rbhtml > $(DEPLOY_FOLDER)/students.html
	./render_template students.rbhtml postdoc > $(DEPLOY_FOLDER)/students_postdoc.html
	./render_template students.rbhtml phd > $(DEPLOY_FOLDER)/students_phd.html
	./render_template students.rbhtml master > $(DEPLOY_FOLDER)/students_master.html
	./render_template students.rbhtml undergraduate > $(DEPLOY_FOLDER)/students_undergraduate.html

alumni: templates/alumni.rbhtml templates/_layout.rbhtml
	./render_template alumni.rbhtml > $(DEPLOY_FOLDER)/alumni.html
	./render_template alumni.rbhtml postdoc > $(DEPLOY_FOLDER)/alumni_postdoc.html
	./render_template alumni.rbhtml phd > $(DEPLOY_FOLDER)/alumni_phd.html
	./render_template alumni.rbhtml master > $(DEPLOY_FOLDER)/alumni_master.html
	./render_template alumni.rbhtml undergraduate > $(DEPLOY_FOLDER)/alumni_undergraduate.html
	./render_template alumni.rbhtml research_scientist > $(DEPLOY_FOLDER)/alumni_research_scientist.html

publications: templates/publications.rbhtml templates/_layout.rbhtml
	./render_template publications.rbhtml > $(DEPLOY_FOLDER)/publications.html

courses: templates/courses.rbhtml templates/_layout.rbhtml
	./render_template courses.rbhtml > $(DEPLOY_FOLDER)/courses.html

getting_involved: templates/getting_involved.rbhtml templates/_layout.rbhtml
	./render_template getting_involved.rbhtml > $(DEPLOY_FOLDER)/getting_involved.html

sponsor: templates/sponsor.rbhtml templates/_layout.rbhtml
	./render_template sponsor.rbhtml > $(DEPLOY_FOLDER)/sponsor.html

faculty: templates/faculty.rbhtml templates/_layout.rbhtml
	./render_template faculty.rbhtml > $(DEPLOY_FOLDER)/faculty.html

software: templates/software.rbhtml templates/_layout.rbhtml
	./render_template software.rbhtml > $(DEPLOY_FOLDER)/software.html

seminar: templates/seminar.rbhtml templates/_layout.rbhtml
	./render_template seminar.rbhtml > $(DEPLOY_FOLDER)/seminar.html
