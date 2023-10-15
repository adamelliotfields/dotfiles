# not https://en.wikipedia.org/wiki/GUID_Partition_Table
function fgpt -d 'FishGPT'
  set -l args \
    'a/api-key=' \
    'completions' \
    'd/dry-run' \
    'frequency=' \
    'h/help' \
    'm/max-tokens=' \
    'no-system' \
    'o/open' \
    'presence=' \
    's/system=' \
    't/temperature='
  argparse $args -- $argv ; or return $status

  # arguments
  set -l prompt "$argv"
  set -l api_key $_flag_a
  set -l frequency $_flag_frequency
  set -l max_tokens $_flag_m
  set -l presence $_flag_presence
  set -l system $_flag_s
  set -l temperature $_flag_t

  # env vars
  test -z "$api_key" ; and set api_key $OPENAI_API_KEY
  test -z "$frequency" ; and set frequency $FISH_GPT_FREQUENCY
  test -z "$max_tokens" ; and set max_tokens $FISH_GPT_MAX_TOKENS
  test -z "$presence" ; and set presence $FISH_GPT_PRESENCE
  test -z "$system" ; and set system $FISH_GPT_SYSTEM
  test -z "$temperature" ; and set temperature $FISH_GPT_TEMPERATURE

  # defaults
  test -z "$max_tokens" ; and set max_tokens null
  test -z "$temperature" ; and set temperature 1
  test -z "$frequency" ; and set frequency 0
  test -z "$presence" ; and set presence 0
  set -l is_tty ; test -t 1 ; and set is_tty true ; or set is_tty false

  # system prompt for completions
  # tune the model's response generation for your use case
  test -z "$system"
    and set system        'You are a helpful assistant.'\n
    and set system $system'You are only able to send a single response to the user as they cannot reply to you.'\n
    and set system $system'Always respond in Markdown format.'

  # help menu and completion text
  set -l api_key_txt 'Your OpenAI API key'
  set -l completions_txt 'Print Fish completions'
  set -l dry_run_txt 'Print the request payload and exit'
  set -l frequency_txt 'Number between -2.0 and 2.0; positive values penalize tokens on frequency (default: 0.0)'
  set -l help_txt 'Print this message and exit'
  set -l max_tokens_txt 'Integer of maximum tokens in response (default: null)'
  set -l no_system_txt 'Disable the default system prompt'
  set -l open_txt 'Open the ChatGPT web app'
  set -l presence_txt 'Number between -2.0 and 2.0; positive values penalize tokens on presence (default: 0.0)'
  set -l system_txt 'Text to use as the system prompt'
  set -l temperature_txt 'Number between 0.0 and 2.0; lower is more deterministic (default: 1.0)'

  # exit early for help
  if set -q _flag_h
    echo 'Interact with the OpenAI GPT 3.5 API'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  fgpt [flags] [--] <prompt>'
    echo
    echo (set_color -o)'PROMPT'(set_color normal)
    echo '  A user message sent to the language model.'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo '  -a, --api-key           '$api_key_txt
    echo '      --completions       '$completions_txt
    echo '  -d, --dry-run           '$dry_run_txt
    echo '      --frequency         '$frequency_txt
    echo '  -h, --help              '$help_txt
    echo '  -m, --max-tokens        '$max_tokens_txt
    echo '      --no-system         '$no_system_txt
    echo '  -o, --open              '$open_txt
    echo '      --presence          '$presence_txt
    echo '  -s, --system            '$system_txt
    echo '  -t, --temperature       '$temperature_txt
    echo
    echo (set_color -o)'ENVIRONMENT VARIABLES'(set_color normal)
    echo '  OPENAI_API_KEY          Overridden by -a/--api-key'
    echo '  FISH_GPT_FREQUENCY      Overridden by --frequency'
    echo '  FISH_GPT_MAX_TOKENS     Overridden by -m/--max-tokens'
    echo '  FISH_GPT_PRESENCE       Overridden by --presence'
    echo '  FISH_GPT_SYSTEM         Overridden by -s/--system'
    echo '  FISH_GPT_TEMPERATURE    Overridden by -t/--temperature'
    return 0
  end

  # print completions
  # usage: fgpt --completions | source
  if set -q _flag_completions
    echo 'complete -c fgpt -f'
    echo "complete -c fgpt -s a -l api-key -d '$api_key_txt'"
    echo "complete -c fgpt -l completions -d '$completions_txt'"
    echo "complete -c fgpt -s d -l dry-run -d '$dry_run_txt'"
    echo "complete -c fgpt -l frequency -d '$frequency_txt'"
    echo "complete -c fgpt -s h -l help -d '$help_txt'"
    echo "complete -c fgpt -s m -l max-tokens -d '$max_tokens_txt'"
    echo "complete -c fgpt -l no-system -d '$no_system_txt'"
    echo "complete -c fgpt -l presence -d '$presence_txt'"
    echo "complete -c fgpt -s s -l system -d '$system_txt'"
    echo "complete -c fgpt -s t -l temperature -d '$temperature_txt'"
    return 0
  end

  if set -q _flag_o
    open https://chat.openai.com
    return 0
  end

  # check for curl and jq
  not command -v curl >/dev/null; or not command -v jq >/dev/null ; and begin
    echo 'fgpt: curl and jq are required'
    return 1
  end

  # check for api key
  if test -z "$api_key"
    echo 'fgpt: OpenAI API key is required'
    return 1
  end

  # check for prompt
  if test -z $prompt[1]
    echo 'fgpt: input prompt is required'
    return 1
  end

  # build the request payload
  set -l messages '[]'
  not set -q _flag_no_system ; and begin
    set -l system_message "{ \"role\": \"system\", \"content\": $(echo -n $system | jq -sRM .) }"
    set messages (echo $messages | jq -M ". + [$system_message]" 2>/dev/null)
    set -l jq_status $pipestatus[2]
    if test "$jq_status" -gt 0
      echo 'fgpt: error parsing system prompt'
      return 1
    end
  end

  set -l user_message "{ \"role\": \"user\", \"content\": $(echo -n $prompt | jq -sRM .) }"
  set messages (echo $messages | jq -cM ". + [$user_message]" 2>/dev/null)
  set -l jq_status $pipestatus[2]
  if test "$jq_status" -gt 0
    echo 'fgpt: error parsing input prompt'
    return 1
  end

  set -l request "\
{
  \"model\": \"gpt-3.5-turbo\",
  \"temperature\": $temperature,
  \"frequency_penalty\": $frequency,
  \"presence_penalty\": $presence,
  \"max_tokens\": $max_tokens,
  \"messages\": $messages
}"

  # if dry run exit now
  set -q _flag_d ; and begin
    echo $request
    return 0
  end

  # set curl options
  set -l c_url https://api.openai.com/v1/chat/completions
  set -l c_opts \
    --fail-with-body \
    -s \
    -L \
    -X POST \
    -H "Authorization: Bearer $api_key" \
    --json $request

  # start spinner if a tty
  set -l spinner_pid 0
  if $is_tty ; and type -q spinner
    printf '%b%b ' \r \U1F318
    fish -c 'spinner -m' &
    set spinner_pid $last_pid
  end

  # make the request
  set -l response (curl $c_opts $c_url)
  set -l c_status $status

  # stop spinner
  if test "$spinner_pid" -gt 0
    kill $spinner_pid
    echo -ne '\r'
  end

  # check for errors
  if test "$c_status" -gt 0
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
  if test "$jq_status" -gt 0
    echo 'fgpt: error parsing response from server'
    echo $response
    return 1
  end

  # print response
  if command -v bat >/dev/null
    echo $content | bat -pp -l md --color=auto
    return 0
  end

  echo $content
end
