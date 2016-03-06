def get_nav_items
  [
    #{
    #  url: "index.html#header",
    #  name: "BAIR",
    #},
    #{
    #  url: "index.html#research",
    #  name: "Research Vision",
    #},
    {
      name: "People",
      url: "#header",
      nested: [
        {
          url: "faculty.html",
          name: "Faculty",
        },
        {
          url: "students.html",
          name: "Students",
        },
        {
          url: "alumni.html",
          name: "Alumni",
        },
      ]
    },
    #{
    #  url: "publications.html",
    #  name: "Publications",
    #},
    {
      name: "Academics",
      url: "#header",
      nested: [
        {
        url: "courses.html",
        name: "Courses",
        },
        {
          url: "seminar.html",
          name: "Seminar",
        },
        {
          url: "textbooks.html",
          name: "Textbooks",
        },

      ],
    },
    {
      url: "software.html",
      name: "Software",
    },
    {
      url: "sponsor.html",
      name: "Industrial Affiliates",
    },
    {
      url: "getting_involved.html",
      name: "Getting Involved",
    }
  ]
end
