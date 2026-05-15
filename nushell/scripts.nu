def "to http" [] {
    let http = $in
    let br = "\n"
    let status = $"HTTP/1.1 ($http.status)"
    let header = ($http.headers.response | each { $"($in.name): ($in.value)" } | str join $br)
    let body = if ($http.body | describe) not-in ["string", "binary"] {
        $http.body | to json
    } else {
        $http.body
    }
    $"($status)($br)($header)($br)($br)($body)" | bat -ppl http
}


def "from jwt" [] {
    let input = $in
    let decode = { base64 -d | from json }

    # Ensure the input is a string
    if ($input | describe) != "string" {
        error make { msg: $"Input must be a string, got ($input | describe)." }
    }

    let parts = ($input | str trim | split row ".")
    if ($parts | length) != 3 {
        error make { msg: "Invalid JWT: Must contain exactly 3 parts separated by dots." }
    }

    let payload = ( $parts.1 | do $decode)
    let payload = if ($payload | get -o scope | describe) == "string" {
        $payload | update scope ($payload.scope | split row " ")
    } else {
        $payload
    }

    {
        header: ( $parts.0 | do $decode )
        payload: $payload
        signature: $parts.2
    }
}
