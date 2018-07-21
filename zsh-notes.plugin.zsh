################################################################################
# Main Method
################################################################################

notes() {
  local MODE_EDIT="edit"
  local MODE_REMOVE="remove"
  local MODE_LIST="list"
  local MODE_HELP="help"
  local MODE_DEFAULT="$MODE_LIST"

  local mode="$MODE_EDIT"

  local -a COMMAND_REMOVE
  COMMAND_REMOVE=(delete remove del rm d r)
  local -a COMMAND_LIST
  COMMAND_LIST=(list ls l)
  local -a COMMAND_EDIT
  COMMAND_EDIT=(edit e)
  local -a COMMAND_HELP
  COMMAND_HELP=(help h)

  local date="$(date +'%Y-%m-%d')"
  local human_date="$(date +'%A, %B %d, %Y (%Y-%m-%d)')"

  local base_path="$HOME/.notes"
  mkdir -p "$base_path"

  local DEFAULT_NOTE_FILE="default"
  local DEFAULT_NOTE_NAME="default"
  local DEFAULT_NOTE_TITLE="General Notes"
  local note_file=""
  local note_title=""
  local note_name=""
  local note_path=""

  local cmd="$1"

  # Process specific modes if provided
  if [[ ${COMMAND_REMOVE[(ie)$cmd]} -le ${#COMMAND_REMOVE} ]]; then
    mode="$MODE_REMOVE"
    shift
    cmd="$1"
  elif [[ ${COMMAND_EDIT[(ie)$cmd]} -le ${#COMMAND_EDIT} ]]; then
    mode="$MODE_EDIT"
    shift
    cmd="$1"
  elif [[ ${COMMAND_LIST[(ie)$cmd]} -le ${#COMMAND_LIST} ]]; then
    mode="$MODE_LIST"
    shift
    cmd="$1"
  elif [[ ${COMMAND_HELP[(ie)$cmd]} -le ${#COMMAND_HELP} ]]; then
    mode="$MODE_HELP"
    shift
    cmd="$1"
  elif [ "$cmd" = "" ]; then
    mode="$MODE_DEFAULT"
  fi

  # If date provided, will open notes for current date
  if [ "$cmd" = "date" ]; then
    note_name="date"
    note_title="Notes for $human_date"
    note_file="$date.md"

  # If nothing provided, will open default note
  elif [ "$cmd" = "" ]; then
    note_name="$DEFAULT_NOTE_NAME"
    note_title="$DEFAULT_NOTE_TITLE"
    note_file="$DEFAULT_NOTE_FILE.md"

  # Otherwise, anything else will be treated as a file for the command
  # e.g. 'notes js' will open js.md note file
  else
    note_name="$cmd"
    note_title="Notes for $cmd"
    note_file="$cmd.md"
  fi

  # Update full path
  note_path="$base_path/$note_file"

  if [ "$mode" = "$MODE_EDIT" ] && [ ! -f "$note_path" ]; then
    builtin echo "# $note_title" >> "$note_path"
    builtin echo "" >> "$note_path"
  fi

  if [ "$mode" = "$MODE_EDIT" ]; then
    $EDITOR "$note_path"
  elif [ "$mode" = "$MODE_REMOVE" ]; then
    if [ ! -f "$note_path" ]; then
      builtin echo "No note exists for $note_name!"
    else
      rm -i "$note_path"
    fi
  elif [ "$mode" = "$MODE_LIST" ]; then
    ls "$base_path"
  elif [ "$mode" = "$MODE_HELP" ]; then
    builtin echo "Usage: notes [<command>] [<name>]

Commands
= $MODE_EDIT =
  Aliases: $COMMAND_EDIT
  Arguments:
    - name: Name of the note to edit without the .md extension

= $MODE_REMOVE =
  Aliases: $COMMAND_REMOVE
  Arguments:
    - name: Name of the note to remove without the .md extension

= $MODE_LIST =
  Aliases: $COMMAND_LIST
  Arguments:

= $MODE_HELP =
  Aliases $COMMAND_HELP
  Arguments:

By default, if no command is provided and no name is provided, all notes will \
be listed.

By default, if no command is provided and a name is provided, the note with the \
provided name will be opened (or created if does not exist) for editing."
  fi
}

