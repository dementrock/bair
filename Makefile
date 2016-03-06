all: index faculty students alumni publications courses getting_involved sponsor software seminar textbooks

DEPLOY_FOLDER=deploy

index: templates/index.rbhtml templates/_layout.rbhtml
	./render_template index.rbhtml > $(DEPLOY_FOLDER)/index.html

students: students_all students_postdoc students_phd students_master students_undergraduate
	
students_all: templates/students.rbhtml templates/_layout.rbhtml
	./render_template students.rbhtml > $(DEPLOY_FOLDER)/students.html

students_postdoc: templates/students.rbhtml templates/_layout.rbhtml
	./render_template students.rbhtml postdoc > $(DEPLOY_FOLDER)/students_postdoc.html

students_phd: templates/students.rbhtml templates/_layout.rbhtml
	./render_template students.rbhtml phd > $(DEPLOY_FOLDER)/students_phd.html

students_master: templates/students.rbhtml templates/_layout.rbhtml
	./render_template students.rbhtml master > $(DEPLOY_FOLDER)/students_master.html

students_undergraduate: templates/students.rbhtml templates/_layout.rbhtml
	./render_template students.rbhtml undergraduate > $(DEPLOY_FOLDER)/students_undergraduate.html

alumni: alumni_all alumni_postdoc alumni_phd alumni_master alumni_undergraduate alumni_research_scientist

alumni_all: templates/alumni.rbhtml templates/_layout.rbhtml
	./render_template alumni.rbhtml > $(DEPLOY_FOLDER)/alumni.html

alumni_postdoc: templates/alumni.rbhtml templates/_layout.rbhtml
	./render_template alumni.rbhtml postdoc > $(DEPLOY_FOLDER)/alumni_postdoc.html

alumni_phd: templates/alumni.rbhtml templates/_layout.rbhtml
	./render_template alumni.rbhtml phd > $(DEPLOY_FOLDER)/alumni_phd.html

alumni_master: templates/alumni.rbhtml templates/_layout.rbhtml
	./render_template alumni.rbhtml master > $(DEPLOY_FOLDER)/alumni_master.html

alumni_undergraduate: templates/alumni.rbhtml templates/_layout.rbhtml
	./render_template alumni.rbhtml undergraduate > $(DEPLOY_FOLDER)/alumni_undergraduate.html

alumni_research_scientist: templates/alumni.rbhtml templates/_layout.rbhtml
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

textbooks: templates/textbooks.rbhtml templates/_layout.rbhtml
	./render_template textbooks.rbhtml > $(DEPLOY_FOLDER)/textbooks.html
