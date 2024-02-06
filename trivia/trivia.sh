#! /usr/bin/env bash

# Get the question data from the API

get_api_data()
{
  local random
  (( random = RANDOM % 10 ))
  curl -s https://opentdb.com/api.php?amount=10 | jq -r  ".results[${random}]" > trivia.json
  while [[ $(cat trivia.json) == null ]]; do
    curl -s https://opentdb.com/api.php?amount=10 | jq -r  ".results[${random}]" > trivia.json 
  done
}

# Extract the relevant info

get_all_info()
{
  difficulty=$(< trivia.json jq -r ".difficulty")
  category=$(< trivia.json jq -r ".category")
  question=$(< trivia.json jq -r ".question")
  correct_answer=$(< trivia.json jq -r  ".correct_answer")
  local i
  for (( i = 0; i < $(< trivia.json jq -r ".incorrect_answers | length"); i++ )); do
      answer["${i}"]=$(< trivia.json jq -r ".incorrect_answers[${i}]") 
  done
  num_answers=$(< trivia.json jq -r ".incorrect_answers | length")
  rm trivia.json
}

# Instructions menu using dialog

begin_menu()
{
  dialog --keep-tite --title 'Welcome to the trivia game' --msgbox 'instructions: 
  1. 10 random questions
  2. 3 difficulties:
  easy (1 point), 
  medium (2 points), 
  hard (3 points)
  3. have fun and get as much points as you can' 0 0
  continue_menu
}

# Option to start or quit the game

continue_menu()
{
  if dialog --keep-tite --yesno 'Do you want to begin?' 0 0; then
    trivia
  else
   exit 0;
  fi
}

# calculate value of points for correct answer by difficulty

question_value()
{
  case "${difficulty}" in 
    hard) points_value=3;;
    medium) points_value=2;;
    easy) points_value=1;;
  esac
}

# instuctions for the next question

instructions()
{
  dialog --keep-tite --msgbox "You have ${points} points
  question ${i}, 
  category: ${category}, 
  difficulty: ${difficulty} (${points_value} points)" 0 0
}

# randomizing the order of the answers. Correct answer will be at a random place

randomize_answers()
{
  correct_and_incorrect=( "$correct_answer" "${answer[@]}" )
 readarray -t random < <(printf "%s\n" "${correct_and_incorrect[@]}" | shuf)
}

# Choose answer menu

choose_answer()
{
  if [[ "${num_answers}" == 1 ]]; then
      decision=$(dialog --keep-tite --no-tags --menu "${question//'&quot;'/'"'}" 0 0 0 "${random[0]}" "${random[0]}" "${random[1]}" "${random[1]}" 2>&1 > /dev/tty)
    else
       decision=$(dialog --keep-tite --no-tags --menu "${question//'&quot;'/'"'}" 0 0 0 "${random[0]}" "${random[0]}" "${random[1]}" "${random[1]}"  "${random[2]}"  "${random[2]}"  "${random[3]}"  "${random[3]}" 2>&1 > /dev/tty)
    fi
}

# the players is asked 10 random questions

trivia()
{
  local i=-1
  while (( i < 10 )); do
    (( i += 1 ))
    get_api_data
    get_all_info
    question_value
    instructions
    randomize_answers
    choose_answer
    if [[ "${decision}" == "${correct_answer}" ]]; then
      (( points += points_value ))
      if ! dialog --keep-tite --yesno "CORRECT! You have ${points} points! Continue?" 0 0; then
        exit 0
      else
        continue
      fi
    else
      if ! dialog --keep-tite --yesno "WRONG! You have ${points} points! Continue?" 0 0; then
        exit 0
      else
        continue
      fi
    fi
  done
  dialog --keep-tite --title 'DONE!' --msgbox "You finished the game with ${points} points!" 0 0
}

# main function

main()
{
  begin_menu
}
main 