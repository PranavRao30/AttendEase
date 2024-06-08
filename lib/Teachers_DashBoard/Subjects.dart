import "package:attend_ease/Teachers_DashBoard/Add_Subject.dart";

var cse1 = [
  "Mathematical foundation for Computer SCience Stream-1",
  "Applied Chemistry for Computer Science Stream",
  "Computer Aided Engineering Drawing",
  "Scientific Foundations For Health",
  "Introduction to Electronics Engineering",
  "Introduction to Electrical Engineering",
  "Introduction to Civil Engineering",
  "Introduction to Mechanical Engineering",
  "Renewable Energy Sources",
  "Sustainable Engineering",
  "Waste Management",
  "Green Buildings",
  "Professional Writing Skills in English",
  "Indian Constitution",
];

var cse2 = [
  "Mathematical foundation for Computer SCience Stream-2",
  "Applied Physics for Computer Science Stream",
  "Principles of Programming in C",
  "Professional Writing Skills in English",
  "Innovation and Design Thinking",
  "Introduction to Electronics Engineering",
  "Introduction to Electrical Engineering",
  "Introduction to Civil Engineering",
  "Introduction to Mechanical Engineering",
  "Introduction to Python Programing",
  "Introduction to Web Programing",
  "Samskrutika Kannada",
  "Balake Kannada",
];

var cse3 = [
  "Statistics and Discrete Mathematics",
  "Computer Organisation & Architecture",
  "Object Oriented Java Programming",
  "Logic Design",
  "Database Management Systems",
  "Data Structures using C",
  "Unix Shell Programming",
  "Full Stack Web development",
  "Physical Education-1",
];

var cse4 = [
  "Cryptography",
  "Operating Systems",
  "Theoretical Foundations of Computations",
  "Software Engineering",
  "Universal Human Values",
  "Analysis and Design of Algorithms",
  "Mobile Application Development",
  "Linear Algebra And Optimization",
  "Physical Education-2",
];

var cse5 = [
  "Cryptography",
  "Internet of Things",
  "Artificial Intelligence",
  "Compiler Design",
  "Wireless and Mobile Communication",
  "Data Exploration and Visualization",
  "Computer Graphics",
  "Advanced Algorithms",
  "Mini Project-1",
  "Biology for CS Engineers",
  "Indian Literature",
];

var cse6 = [
  "Blockchain",
  "Machine Learning",
  "Software Engineering and Object Oriented Modelling",
  "Advanced Computer Networks",
  "Big Data Analytics",
  "Computer Vision and Image Processing",
  "Advanced Data Structures",
  "Artificial Intelligence",
  "Cryptography",
  "Data Structures using C",
  "Mini Project -2",
  "Internship Based Seminar",
  "Management and Entrepreneurship",
  "Personality development, Aptitude and Communication Skills",
];

var cse7 = [
  "Cloud Computing",
  "Network Programming",
  "Soft Computing",
  "Natural Language Processing",
  "Robot Process Automation Design and Development",
  "Network Security",
  "Neural network and Deep Learning",
  "Human Computer Interaction, Virtual,Augmented Reality",
  "High Performance Computing",
  "Machine Learning",
  "Information and Network security",
  "Analysis and design of Algorithms",
  "Major Project Phase 1",
  "Cyber Law Forensics and IPR",
  "MOOCs Course -1",
];

var cse8 = [
  "Major Project Phase 2",
  "Deep Learning",
  "Cyber Security",
  "Object Oriented Programming with Java",
  "Green Computing",
  "Internship",
  "MOOCs Course -2",
];

get_courses(dropdownvalue_branch, dropdownvalue_semester) {
  if (dropdownvalue_semester == 1) {
    dropdown_course = "Applied Chemistry for Computer Science Stream";
    return cse1;
  } else if (dropdownvalue_semester == 2) {
    dropdown_course = "Applied Physics for Computer Science Stream";
    return cse2;
  } else if (dropdownvalue_semester == 3) {
    dropdown_course = "Logic Design";
    return cse3;
  } else if (dropdownvalue_semester == 4) {
    dropdown_course = "Cryptography";
    return cse4;
  } else if (dropdownvalue_semester == 5) {
    dropdown_course = "Internet of Things";
    return cse5;
  } else if (dropdownvalue_semester == 6) {
    dropdown_course = "Blockchain";
    return cse6;
  } else if (dropdownvalue_semester == 7) {
    dropdown_course = "Machine Learning";
    return cse7;
  } else if (dropdownvalue_semester == 8) {
    dropdown_course = "Deep Learning";
    return cse8;
  }
}