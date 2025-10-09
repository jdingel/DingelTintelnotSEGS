#!/bin/bash
# Script to parse exhibits.tex and Makefile to generate a Markdown table of exhibits

input_tex="exhibits.tex"
makefile="Makefile"
output_file="../output/exhibits_table.md"
mkdir -p "$(dirname "$output_file")"

# Initialize variables
in_appendix=false
appendix_letters=({A..Z})
appendix_section_count=-1
figure_counter=0
table_counter=0
exhibit_counter=0

# Markdown header
{
    echo "| Exhibit | Task Folder | Output File |"
    echo "|---------|-------------|-------------|"
} > "$output_file"

# Search for lines in exhibits.tex with \includegraphics[*]{filepath} or \input[*]{filepath} and extract "filepath"
extract_input_files() {
    grep -Eo '\\includegraphics(\[[^]]*\])?\{[^}]+\}|\\input\{[^}]+\}' <<< "$1" |
    sed -E 's/\\includegraphics(\[[^]]*\])?\{([^}]+)\}.*/\2/; s/\\input\{([^}]+)\}.*/\1/'
}

# Parse through Makefile and obtain task folder
get_task_folder() {
    local file="$1"
    local rule folder

    # Case 1: exact appearance in a rule
    rule=$(grep -m1 -F "../input/$file" "$makefile")
    if [[ -n "$rule" ]]; then
        folder=$(sed -n 's|.*\.\./\.\./\([^/]*\)/.*|\1|p' <<< "$rule" | head -1)
        [[ -n $folder ]] && { echo "$folder"; return; }
    fi

    # Case 2: match a pattern rule like ../input/foo_%.eps
    while IFS= read -r line; do
        target=$(sed -n 's|^\(../input/[^:]*\):.*|\1|p' <<< "$line")
        [[ -z $target ]] && continue

        regex="^${target//%/.+}$"
        if [[ "../input/$file" =~ $regex ]]; then
            folder=$(sed -n 's|.*\.\./\.\./\([^/]*\)/.*|\1|p' <<< "$line" | head -1)
            [[ -n $folder ]] && { echo "$folder"; return; }
        fi
    done < <(grep -E "^\.\./input/.*%.*:" "$makefile")

    # Case 3: brute-force fallback
    found=$(find ../../ -type f -path "*/output/$file" 2>/dev/null | head -1)
    if [[ -n "$found" ]]; then
        folder=$(sed -n 's|.*/\([^/]*\)/output/.*|\1|p' <<< "$found")
        [[ -n $folder ]] && { echo "$folder"; return; }
    fi

    echo "?"
}

get_exhibit_name() {
    local type="$1"  # "Figure" or "Table"
    local count="$2"

    # If not in appendix, or appendix has started but we have not entered an exhibit section yet, use main text numbering.
    if ! $in_appendix || [[ $appendix_section_count -lt 0 ]]; then
        echo "$type $count"
    else
        local section=${appendix_letters[appendix_section_count]} # Otherwise use appendix_letters
        echo "$type ${section}.$count"
    fi
}

while IFS= read -r line; do
    # When \appendix appears, initialize variables for counting
    [[ $line =~ \\appendix ]] && in_appendix=true && appendix_section_count=-1 && figure_counter=0 && table_counter=0

    # When in_appendix is true and \section appears, increment appendix_section_count and reset figure and table counts
    if [[ $in_appendix == true && $line =~ \\section ]]; then
        ((appendix_section_count++))
        figure_counter=0
        table_counter=0
    fi
    for env in figure table; do
        if [[ $line =~ \\begin\{$env\} ]]; then # increment counter on lines with \begin{$env}
            ((exhibit_counter++))
            block="$line"
            while IFS= read -r next_line && [[ ! "$next_line" =~ \\end\{$env\} ]]; do
                block+=$'\n'"$next_line"
            done
            block+=$'\n'"$next_line"

            # Increment figure/table counter and retrieve exhibit_name
            if [[ "$env" == "figure" ]]; then
                ((figure_counter++))
                exhibit_name=$(get_exhibit_name "Figure" "$figure_counter")
            else
                ((table_counter++))
                exhibit_name=$(get_exhibit_name "Table" "$table_counter")
            fi

            input_files=$(extract_input_files "$block") # use function extract_input_files() for given line
            if [[ -n "$input_files" ]]; then
                while IFS= read -r input_file; do
                    file=$(basename "$input_file")
                    task_folder=$(get_task_folder "$file")
                    echo "| $exhibit_name | $task_folder | $file |" >> "$output_file" # write line to markdown output
                done <<< "$input_files"
            else
                echo "| $exhibit_name | [not retrieved] | [not retrieved] |" >> "$output_file"
            fi
        fi
    done
done < "$input_tex"

echo "Total exhibits processed: $exhibit_counter"
echo "Output file saved to: $output_file"