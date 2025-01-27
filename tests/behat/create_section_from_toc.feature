# This file is part of Moodle - http://moodle.org/
#
# Moodle is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Moodle is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Moodle.  If not, see <http://www.gnu.org/licenses/>.
#
#
# @package    theme_snap
# @copyright Copyright (c) 2015 Blackboard Inc. (http://www.blackboard.com)
# @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later

@theme @theme_snap
Feature: In the Snap theme, within a course, editing teachers can create a new section by clicking on a
  link in the TOC which reveals a form.
  This requires the course to use the weeks and topics format.

  Background:
  Given the following "courses" exist:
      | fullname               | shortname     | category | groupmode | format         | startdate  |
      | Topics course          | course_topics | 0        | 1         | topics         |            |
      | Weeks course           | course_weeks  | 0        | 1         | weeks          | 1457078400 |
      | Single activity course | course_single | 0        | 1         | singleactivity |            |
      | Social course          | course_social | 0        | 1         | social         |            |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | teacher2 | Teacher   | 2        | teacher2@example.com |
      | student1 | Student   | 1        | student1@example.com |
    And the following "course enrolments" exist:
      | user | course | role           |
      | teacher1 | course_topics | editingteacher |
      | teacher1 | course_weeks  | editingteacher |
      | teacher1 | course_single | editingteacher |
      | teacher1 | course_social | editingteacher |
      | teacher2 | course_topics | teacher        |
      | teacher2 | course_weeks  | teacher        |
      | teacher2 | course_single | teacher        |
      | teacher2 | course_social | teacher        |
      | student1 | course_topics | student        |
      | student1 | course_weeks  | student        |
      | student1 | course_single | student        |
      | student1 | course_social | student        |

  @javascript
  Scenario Outline: For editing teachers, ensure new section creation is available and works for topic courses but
    not single activity or social course formats.
  Given I log in as "admin"
  And the following config values are set as admin:
    | coursepartialrender | <Option> | theme_snap |
  And I log out
  Then I log in as "teacher1"
    And I create a new section in course "course_topics"
   Then I should see "New section title" in the "#course-toc" "css_element"

    # Negative test - the single activity course should not allow for section creation via the toc.
    And I am on the course main page for "course_single"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    # Negative test - the social course should not allow for section creation via the toc.
    And I am on the course main page for "course_social"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    # Make sure student can see the sections created by the teacher in Topics and Weeks format courses.
    And I log out
    And I log in as "student1"
    And I am on the course main page for "course_topics"
   Then I should see "New section title" in the "#course-toc" "css_element"
  Examples:
    | Option     |
    | 0          |
    | 1          |

  @javascript
  Scenario: For non editing teachers and students, ensure new section creation is not available for any course formats.
  Given I log in as "teacher2"
    And I am on the course main page for "course_topics"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    And I am on the course main page for "course_weeks"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    And I am on the course main page for "course_single"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    And I am on the course main page for "course_social"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    And I log out
    And I log in as "student1"
    And I am on the course main page for "course_topics"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    And I am on the course main page for "course_weeks"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    And I am on the course main page for "course_single"
   Then I should not see "Create a new section" in the "#page-header" "css_element"
    And I am on the course main page for "course_social"
   Then I should not see "Create a new section" in the "#page-header" "css_element"


   @javascript
  Scenario Outline: For editing teachers, ensure new section creation is available for week format and creates the section with a default title.
   Given I log in as "admin"
   And the following config values are set as admin:
     | coursepartialrender | <Option> | theme_snap |
   And I log out
    Then I log in as "teacher1"
    Then I am on the course main page for "course_weeks"
     And I follow "Create a new section"
    Then I should see "Title: 8 April - 14 April"
     And I click on "Create section" "button"
     And I log out
     And I log in as "student1"
     And I am on the course main page for "course_weeks"
    Then I should see "8 April - 14 April" in the "#course-toc" "css_element"
   Examples:
     | Option     |
     | 0          |
     | 1          |