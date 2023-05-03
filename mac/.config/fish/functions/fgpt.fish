function fgpt -d 'FishGPT'
  # help menu
  set -l api_key_txt 'Your OpenAI API key'
  set -l completions_txt 'Print Fish completions'
  set -l dry_run_txt 'Print the request payload and exit'
  set -l frequency_txt 'Number between -2.0 and 2.0; positive values penalize tokens on frequency (default: 0.0)'
  set -l help_txt 'Print this message and exit'
  set -l max_tokens_txt 'Integer of maximum tokens in response (default: null)'
  set -l no_system_txt 'Disable the default system prompt'
  set -l presence_txt 'Number between -2.0 and 2.0; positive values penalize tokens on presence (default: 0.0)'
  set -l file_txt 'File path to save the conversation to (default: undefined)'
  set -l system_txt 'Text to use as the system prompt'
  set -l temperature_txt 'Number between 0.0 and 2.0; lower is more deterministic (default: 1.0)'
  set -l wrap_txt 'Integer of characters to wrap the response at (0 to disable) (default: 100)'

  set -l help_menu "fgpt\n
Interact with the OpenAI GPT 3.5 API. Depends on curl and jq.\n\nSee https://platform.openai.com/docs/api-reference\n
EXAMPLES:\n
fgpt 'What is the capital of France?'\n
fgpt 'Is this thing on?' -d | jq # pretty-print the request payload\n
fgpt 'Let's have a chat!' -f /tmp/chat.json\n
fgpt 'Generate a unique ice cream flavor idea.' -t1.5\n
fgpt 'Help me debug the error in this class.' -s \"\$(cat system.txt)\" # quotes are required here\n
USAGE:
  fgpt <PROMPT> [FLAGS]\n
PROMPT:
  A user message sent to the language model.\n
FLAGS:
  -a, --api-key           $api_key_txt
      --completions       $completions_txt
  -d, --dry-run           $dry_run_txt
      --frequency         $frequency_txt
  -h, --help              $help_txt
  -m, --max-tokens        $max_tokens_txt
      --no-system         $no_system_txt
      --presence          $presence_txt
  -f, --file              $file_txt
  -s, --system            $system_txt
  -t, --temperature       $temperature_txt
  -w, --wrap              $wrap_txt\n
ENV:
  OPENAI_API_KEY          Overridden by -a/--api-key
  FISH_GPT_FREQUENCY      Overridden by --frequency
  FISH_GPT_MAX_TOKENS     Overridden by -m/--max-tokens
  FISH_GPT_PRESENCE       Overridden by --presence
  FISH_GPT_SAVE_FILE      Overridden by -f/--file
  FISH_GPT_SYSTEM         Overridden by -s/--system
  FISH_GPT_TEMPERATURE    Overridden by -t/--temperature
  FISH_GPT_WRAP           Overridden by -w/--wrap"

  set -l args \
    'a/api-key=' \
    'completions' \
    'd/dry-run' \
    'f/file=' \
    'frequency=' \
    'h/help' \
    'm/max-tokens=' \
    'no-system' \
    'presence=' \
    's/system=' \
    't/temperature=' \
    'w/wrap='

  argparse $args -- $argv ; or return 1

  # arguments
  set -l prompt $argv[1]
  set -l api_key $_flag_a
  set -l completions $_flag_completions
  set -l dry_run $_flag_d
  set -l _file $_flag_f
  set -l frequency $_flag_frequency
  set -l _help $_flag_h
  set -l max_tokens $_flag_m
  set -l no_system $_flag_no_system
  set -l presence $_flag_presence
  set -l system $_flag_s
  set -l temperature $_flag_t
  set -l wrap $_flag_w

  # env vars
  test -z "$api_key" ; and set api_key $OPENAI_API_KEY
  test -z "$frequency" ; and set frequency $FISH_GPT_FREQUENCY
  test -z "$max_tokens" ; and set max_tokens $FISH_GPT_MAX_TOKENS
  test -z "$presence" ; and set presence $FISH_GPT_PRESENCE
  test -z "$_file" ; and set _file $FISH_GPT_SAVE_FILE
  test -z "$temperature" ; and set temperature $FISH_GPT_TEMPERATURE
  test -z "$wrap" ; and set wrap $FISH_GPT_WRAP

  # defaults
  test -z $max_tokens ; and set max_tokens null
  test -z $temperature ; and set temperature 1
  test -z $frequency ; and set frequency 0
  test -z $presence ; and set presence 0
  test -z $wrap ; and set wrap 100
  set -l messages '[]'

  # system prompt for completions
  # tune the model's response generation for your use case
  test -z "$system"
    and set system "\
You are a friendly AI language model trained to generate concise responses.
Refrain from mentioning your AI nature and limitations.
Default to responding in Markdown format."

  # exit early for help
  if test -n "$_help"
    echo -e $help_menu
    return 0
  end

  # print completions
  # usage: fgpt --completions | source
  if test -n "$completions"
    echo "\
complete -c fgpt -f
complete -c fgpt -s a -l api-key -d '$api_key_txt'
complete -c fgpt -l completions -d '$completions_txt'
complete -c fgpt -s d -l dry-run -d '$dry_run_txt'
complete -c fgpt -l frequency -d '$frequency_txt'
complete -c fgpt -s h -l help -d '$help_txt'
complete -c fgpt -s m -l max-tokens -d '$max_tokens_txt'
complete -c fgpt -l no-system -d '$no_system_txt'
complete -c fgpt -l presence -d '$presence_txt'
complete -c fgpt -s f -l file -d '$file_txt'
complete -c fgpt -s s -l system -d '$system_txt'
complete -c fgpt -s t -l temperature -d '$temperature_txt'
complete -c fgpt -s w -l wrap -d '$wrap_txt'"
    return 0
  end

  # check for curl and jq
  if not command -v curl >/dev/null; or not command -v jq >/dev/null
    echo 'fgpt: curl and jq are required'
    return 1
  end

  # check for api key
  if test -z $api_key
    echo 'fgpt: OpenAI API key is required'
    return 1
  end

  # check for prompt
  if test -z $prompt[1]
    echo 'fgpt: input prompt is required'
    return 1
  end

  # chat mode
  if test -n "$_file"
    # if the file doesn't exist create it
    if test ! -e "$_file"
      echo $messages | tee $_file >/dev/null
    end

    # jq reference:
    #   -M: monochrome output
    #   -R: raw input (i.e., JSON.stringify())
    #   -r: raw output, not quoted (i.e., JSON.parse())
    #   -c: compact output (minified)
    #   -s: slurp, when used with -R, converts newlines to "\n"
    if test -s $_file
      # check if we can parse the save file
      set messages (cat $_file | jq -M ". + []" 2>/dev/null)
      set -l jq_status $pipestatus[2]
      if test $jq_status -gt 0
        echo "fgpt: $_file must contain a valid JSON array"
        return 1
      end
    end
  end

  # build the request payload
  # only add the system message if there are no existing messages
  if test -z "$no_system" ; and test (echo -n $messages | jq length) -eq 0
    set -l system_message "{ \"role\": \"system\", \"content\": $(echo -n $system | jq -sRM .) }"
    set messages (echo $messages | jq -M ". + [$system_message]" 2>/dev/null)
    set -l jq_status $pipestatus[2]
    if test $jq_status -gt 0
      echo 'fgpt: error parsing system prompt'
      return 1
    end
  end

  set -l user_message "{ \"role\": \"user\", \"content\": $(echo -n $prompt | jq -sRM .) }"
  set messages (echo $messages | jq -cM ". + [$user_message]" 2>/dev/null)
  set -l jq_status $pipestatus[2]
  if test $jq_status -gt 0
    echo 'fgpt: error parsing input prompt'
    return 1
  end

  set -l request "{
    \"model\": \"gpt-3.5-turbo\",
    \"temperature\": $temperature,
    \"frequency_penalty\": $frequency,
    \"presence_penalty\": $presence,
    \"max_tokens\": $max_tokens,
    \"messages\": $messages
  }"

  # if dry run exit now
  if test -n "$dry_run"
    echo $request
    return 0
  end

  # set curl options
  set -l url https://api.openai.com/v1/chat/completions
  set -l opts \
    --fail-with-body \
    -s \
    -L \
    -X POST \
    -H "Authorization: Bearer $api_key" \
    --json $request

  # start spinner
  set -l spinner_pid 0
  if type -q spinner
    printf '%b%b ' \r \U1F318
    fish -c 'spinner -m' &
    set spinner_pid $last_pid
  end

  # make the request
  set -l response (curl $opts $url)
  set -l curl_status $status

  # stop spinner
  if test $spinner_pid -gt 0
    kill $spinner_pid
    echo -ne '\r'
  end

  # check for errors
  if test $curl_status -gt 0
    if test -n "$response"
      set -l err (echo -n $response | jq -rM .error.message)
      echo "fgpt: $err"
    else
      echo 'fgpt: server error'
    end
    return 1
  end

  # parse content from response
  set -l content "$(echo -n $response | jq -rM .choices[0].message.content)"
  set -l jq_status $pipestatus[2]
  if test $jq_status -gt 0
    echo 'fgpt: error parsing response from server'
    echo $response
    return 1
  end

  # write to file if flag is set
  if test -n "$_file"
    set -l assistant_message "{ \"role\": \"assistant\", \"content\": $(echo $content | jq -RM .) }"
    set messages "$(echo $messages | jq -M ". + [$assistant_message]")"

    # ensure messages isn't empty before writing
    if test -n "$messages" ; and test -w "$_file"
      echo $messages | tee $_file >/dev/null
    end
  end

  # print response
  # wrap if requested
  if test -n "$wrap" ; and test "$wrap" -gt 0 2>/dev/null ; and command -v fold >/dev/null
    # the -s flag breaks on whitespace only (keeps words together)
    echo $content | fold -w $wrap -s
    return 0
  end

  echo $content
end
