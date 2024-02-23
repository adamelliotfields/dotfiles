function chat -d 'chat.fish'
  set -l args \
    'a/api-key=' \
    'completions' \
    'd/dry-run' \
    'frequency=' \
    'h/help' \
    'host=' \
    'max-tokens=' \
    'm/model=' \
    'no-system' \
    'presence=' \
    's/save=?' \
    'system=' \
    't/temperature='
  argparse $args -- $argv ; or return $status

  # default models
  set -l DEFAULT_PERPLEXITY pplx-70b-chat
  set -l DEFAULT_OPENAI gpt-3.5-turbo

  # app name
  set -l app chat

  # arguments
  set -l prompt "$argv"
  set -l api_key $_flag_a
  set -l frequency $_flag_frequency
  set -l host $_flag_host
  set -l max_tokens $_flag_max_tokens
  set -l model $_flag_m
  set -l presence $_flag_presence
  set -l system $_flag_system
  set -l temperature $_flag_t

  # env vars
  test -z "$frequency" ; and set frequency $FISH_CHAT_FREQUENCY
  test -z "$host" ; and set host $FISH_CHAT_HOST
  test -z "$max_tokens" ; and set max_tokens $FISH_CHAT_MAX_TOKENS
  test -z "$model" ; and set model $FISH_CHAT_MODEL
  test -z "$presence" ; and set presence $FISH_CHAT_PRESENCE
  test -z "$system" ; and set system $FISH_CHAT_SYSTEM
  test -z "$temperature" ; and set temperature $FISH_CHAT_TEMPERATURE

  # defaults
  test -z "$host" ; and set host perplexity
  test -z "$max_tokens" ; and set max_tokens null
  test -z "$model" ; and set model $DEFAULT_PERPLEXITY
  test -z "$temperature" ; and set temperature 1
  test -z "$frequency" ; and set frequency 0
  test -z "$presence" ; and set presence 0
  set -l is_tty ; test -t 1 ; and set is_tty true ; or set is_tty false
  set -l save_file chat.json
  set -l messages '[]'

  # url
  set -l url
  switch $host
    case perplexity
      set url https://api.perplexity.ai
    case openai
      set url https://api.openai.com/v1
    case '*'
      echo "$app: host must be 'perplexity' or 'openai' (got '$host')"
      return 1
  end

  # don't use perplexity models at openai
  test "$host" = openai ; and test "$model" = $DEFAULT_PERPLEXITY ; and set model $DEFAULT_OPENAI

  # frequency of 0 at OpenAI is 1 at Perplexity
  test "$host" = perplexity ; and test "$frequency" = 0 ; and set frequency 1

  # api keys
  test "$host" = openai ; and test -z "$api_key" ; and set api_key $OPENAI_API_KEY
  test "$host" = perplexity ; and test -z "$api_key" ; and set api_key $PERPLEXITY_API_KEY

  # help menu and completion text
  set -l api_key_txt 'Your OpenAI/Perplexity API key'
  set -l completions_txt 'Print Fish completions'
  set -l dry_run_txt 'Print the request payload and exit'
  set -l frequency_txt 'Number between -2.0 and 2.0; positive values penalize tokens on frequency (default: 1 if perplexity; 0 if openai)'
  set -l help_txt 'Print this message and exit'
  set -l host_txt 'The API host to use (perplexity|openai) (default: perplexity)'
  set -l max_tokens_txt 'Integer of maximum tokens in response (default: null)'
  set -l model_txt "The model to use for completion (default: $DEFAULT_PERPLEXITY if perplexity; $DEFAULT_OPENAI if openai)"
  set -l no_system_txt 'Disable the default system prompt'
  set -l presence_txt 'Number between -2.0 and 2.0; positive values penalize tokens on presence (default: 0.0)'
  set -l save_txt 'Save the response to an optionally-named file (default: `chat.json` if true)'
  set -l system_txt 'Text to use as the system prompt'
  set -l temperature_txt 'Number between 0.0 and 2.0; lower is more deterministic (default: 1.0)'

  # exit early for help
  if set -q _flag_h
    echo $app'.fish'
    echo
    echo (set_color -o)'USAGE'(set_color normal)
    echo '  '$app' [flags] [--] <prompt>'
    echo
    echo (set_color -o)'PROMPT'(set_color normal)
    echo '  A user message sent to the language model.'
    echo
    echo (set_color -o)'FLAGS'(set_color normal)
    echo '  -a, --api-key            '$api_key_txt
    echo '      --completions        '$completions_txt
    echo '  -d, --dry-run            '$dry_run_txt
    echo '      --frequency          '$frequency_txt
    echo '  -h, --help               '$help_txt
    echo '      --host               '$host_txt
    echo '      --max-tokens         '$max_tokens_txt
    echo '  -m, --model              '$model_txt
    echo '      --no-system          '$no_system_txt
    echo '      --presence           '$presence_txt
    echo '  -s, --save               '$save_txt
    echo '      --system             '$system_txt
    echo '  -t, --temperature        '$temperature_txt
    echo
    echo (set_color -o)'ENVIRONMENT VARIABLES'(set_color normal)
    echo '  OPENAI_API_KEY           Overridden by -a/--api-key'
    echo '  PERPLEXITY_API_KEY       Overridden by -a/--api-key'
    echo '  FISH_CHAT_FREQUENCY      Overridden by --frequency'
    echo '  FISH_CHAT_HOST           Overridden by --host'
    echo '  FISH_CHAT_MAX_TOKENS     Overridden by --max-tokens'
    echo '  FISH_CHAT_MODEL          Overridden by -m/--model'
    echo '  FISH_CHAT_PRESENCE       Overridden by --presence'
    echo '  FISH_CHAT_SYSTEM         Overridden by --system'
    echo '  FISH_CHAT_TEMPERATURE    Overridden by -t/--temperature'
    return 0
  end

  # print completions
  # usage: chat --completions | source
  if set -q _flag_completions
    echo "complete -c $app -f"
    echo "complete -c $app -s a -l api-key -d '$api_key_txt'"
    echo "complete -c $app -l completions -d '$completions_txt'"
    echo "complete -c $app -s d -l dry-run -d '$dry_run_txt'"
    echo "complete -c $app -l frequency -d '$frequency_txt'"
    echo "complete -c $app -s h -l help -d '$help_txt'"
    echo "complete -c $app -l host -d '$host_txt'"
    echo "complete -c $app -l max-tokens -d '$max_tokens_txt'"
    echo "complete -c $app -s m -l model -d '$model_txt'"
    echo "complete -c $app -l no-system -d '$no_system_txt'"
    echo "complete -c $app -l presence -d '$presence_txt'"
    echo "complete -c $app -s s -l save -d '$save_txt'"
    echo "complete -c $app -l system -d '$system_txt'"
    echo "complete -c $app -s t -l temperature -d '$temperature_txt'"
    return 0
  end

  # check for curl and jq
  not command -v curl >/dev/null; or not command -v jq >/dev/null ; and begin
    echo $app': curl and jq are required'
    return 1
  end

  # check for api key
  if test -z "$api_key"
    echo $app': API key is required'
    return 1
  end

  # check for prompt
  if test -z $prompt[1]
    echo $app': input prompt is required'
    return 1
  end

  # exit if model ends with `-online` as these incur a bulk charge of $5 per 1000 requests
  string match -rq -- '-online$' $model ; and begin
    echo $app': use https://pplx.ai for online models'
    return 1
  end

  # system prompt for completions
  # tune the model's response generation for your use case
  set -l has_system
  test -n "$system" ; and set has_system true ; or set has_system false
  test -z "$system" ; and set system 'You are a helpful assistant.'\n'Answer questions comprehensively while respecting brevity.'\n'Your responses are rendered as Markdown.'

  # if not saving let the model know
  not set -q _flag_s ; and not set -q _flag_no_system ; and test "$has_system" = false ; and set system $system\n'This is a single-turn conversation; the user cannot respond.'

  # if saving read the file or initialize it
  set -q _flag_s ; and begin
    test -n "$_flag_s" ; and set save_file $_flag_s
    test -s "$save_file" ; or echo $messages > $save_file
    set messages (cat $save_file | jq -cM . 2>/dev/null)
    # if the file is malformed let the user know
    set -l jq_status $pipestatus[2]
    if test "$jq_status" -gt 0
      echo "$app: error reading save file '$save_file'"
      return 1
    end
  end

  # add system message if messages is empty
  not set -q _flag_no_system ; and begin
    test "$(echo $messages | jq length)" -eq 0 ; and begin
      set -l system_message "{ \"role\": \"system\", \"content\": $(echo -n $system | jq -sRM .) }"
      set messages (echo $messages | jq -cM ". + [$system_message]" 2>/dev/null)
    end
  end

  # add user message
  set -l user_message "{ \"role\": \"user\", \"content\": $(echo -n $prompt | jq -sRM .) }"
  set messages (echo $messages | jq -cM ". + [$user_message]" 2>/dev/null)
  set -l jq_status $pipestatus[2]
  if test "$jq_status" -gt 0
    echo $app': error parsing input prompt'
    return 1
  end

  set -l request "\
{
  \"model\": \"$model\",
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
  set -l curl_url "$url/chat/completions"
  set -l curl_opts \
    --fail-with-body \
    -s \
    -m 30 \
    -X POST \
    -H "Authorization: Bearer $api_key" \
    -H "Content-Type: application/json" \
    -d $request

  # start spinner if a tty (see `spinner.fish`)
  set -l spinner_pid 0
  if $is_tty ; and type -q spinner
    printf '%b%b ' \r \U1F318
    fish -c 'spinner -m' &
    set spinner_pid $last_pid
  end

  # make the request
  set -l response (curl $curl_opts $curl_url)
  set -l curl_status $status

  # stop spinner
  if test "$spinner_pid" -gt 0
    kill $spinner_pid
    echo -ne '\r'
  end

  # check for errors
  if test "$curl_status" -gt 0
    if test -n "$response"
      # print error message from server
      set -l err (echo -n $response | jq -rM .error.message)
      echo "$app: $err"
    else
      echo $app': server error'
    end
    return 1
  end

  # parse content from response
  set -l content "$(echo -n $response | jq -rM .choices[0].message.content)"
  set -l jq_status $pipestatus[2]
  if test "$jq_status" -gt 0
    echo $app': error parsing response from server'
    echo $response
    return 1
  end

  # if saving write to file
  set -q _flag_s ; and begin
    set -l assistant_message "{ \"role\": \"assistant\", \"content\": $(echo -n $content | jq -sRM .) }"
    set messages (echo $messages | jq -cM ". + [$assistant_message]" 2>/dev/null)
    echo $messages | jq -M > $save_file
  end

  # print response
  if command -v bat >/dev/null
    echo $content | bat -pp -l md --color=auto
    return 0
  end

  echo $content
end
