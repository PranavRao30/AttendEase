var sections = Map();
var sem;
select_sections(dropdownvalue_branch, current_cycle) {
  //Even Cycle
  if (current_cycle == "Even") {
    get_sections(dropdownvalue_branch, 2);
  } else if (current_cycle == "Odd") {
    get_sections(dropdownvalue_branch, 1);
  }

  // print(sections);
}


// Getting Sections
get_sections(dropdownvalue_branch, c) {
  if (dropdownvalue_branch == "CSE") {
    for (int i = c; i <= 8; i += 2) {
      sections['${i}'] = ['A', 'B', 'C', 'D', 'E', 'F'];
    }
  } else if (dropdownvalue_branch == "AIML") {
    for (int i = c; i <= 8; i += 2) {
      sections['${i}'] = ['A', 'B', 'C'];
    }
  } else if (dropdownvalue_branch == "EC") {
    for (int i = c; i <= 8; i += 2) {
      sections['${i}'] = ['A', 'B', 'C', 'D', 'E'];
    }
  } else if (dropdownvalue_branch == "EI" ||
      dropdownvalue_branch == 'ET' ||
      dropdownvalue_branch == "BT") {
    for (int i = c; i <= 8; i += 2) {
      sections['${i}'] = ['A'];
    }
  } else if (dropdownvalue_branch == "CSIOT" ||
      dropdownvalue_branch == "AIDS" ||
      dropdownvalue_branch == "CSDS") {
    for (int i = c; i <= 4; i += 2) {
      sections['${i}'] = ['A'];
    }
  }
}



new_Arrival(dropdownvalue_branch, current_cycle) {
  if ((dropdownvalue_branch == "CSIOT" ||
          dropdownvalue_branch == "AIDS" ||
          dropdownvalue_branch == "CSDS") &&
      (current_cycle == "Even")) {
    sem = [2, 4];
    return sem;
  } else if ((dropdownvalue_branch == "CSIOT" ||
          dropdownvalue_branch == "AIDS" ||
          dropdownvalue_branch == "CSDS") &&
      (current_cycle == "Odd")) {
    sem = [1, 3];
    return sem;
  }
}

void main() {
  select_sections("CSE", "Odd");
}

// var branch_codes = [
//   'AE',
//   'AIDS',
//   'AIML',
//   'BT',
//   'CH',
//   'CSBS',
//   'CSDS',
//   'CSE',
//   'CSIOT',
//   'CV',
//   'EC',
//   'EEE',
//   'EI',
//   'ET',
//   'IEM',
//   'ISE',
//   'MD',
//   'ME',
// ];
