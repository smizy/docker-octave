@test "octave is the correct version" {
  run docker run smizy/octave:${TAG} octave -q --eval 'version'
  echo "${output}" 

  [ $status -eq 0 ]

  result="${lines[0]}"

  [ "${result}" = "ans = ${VERSION}" ]
}